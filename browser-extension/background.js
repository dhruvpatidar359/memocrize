chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "sendText",
    title: "Send selected text to server",
    contexts: ["selection"]
  });

  chrome.contextMenus.create({
    id: "sendImage",
    title: "Send image to server",
    contexts: ["image"]
  });

  chrome.contextMenus.create({
    id: "sendScreenshot",
    title: "Send screenshot to server",
    contexts: ["all"] 
  });

  chrome.contextMenus.create({
    id: "selectAreaAndSendScreenshot",
    title: "Select area and send screenshot",
    contexts: ["all"]
  });
});


chrome.commands.onCommand.addListener((command) => {
  if (command === "take-partial-screenshot") {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
      let activeTab = tabs[0];
      initiateScreenshotCapture(activeTab);
    });
  }
});

function initiateScreenshotCapture(tab)  {
  chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" },async (dataUrl) => {
    if (dataUrl) {
      const token = await getGoogleAccessToken();
      chrome.scripting.executeScript({
        target: { tabId: tab.id },
        function: injectScreenshotCode,
        args: [dataUrl, token] // You'll need to implement getGoogleAccessToken()
      });
    } else {
      console.error("Failed to capture screenshot");
    }
  });
}

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  try {
    const token = await getGoogleAccessToken();

    if (!token) {
      chrome.tabs.create({ url: "http://localhost:3000/signin" });
      return;
    }

    if (info.menuItemId === "sendText") {
      const selectedText = info.selectionText;
      if (selectedText) {
        sendTextToServer(selectedText, token);
      }
    } else if (info.menuItemId === "sendImage") {
      const imageUrl = info.srcUrl;
      if (imageUrl) {
        sendImageToServer(imageUrl, token);
      }
    } else if (info.menuItemId === "sendScreenshot") {
      // Capture the visible area of the current tab and send it to the server
      chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" }, (dataUrl) => {
        if (dataUrl) {
          sendScreenshotToServer(dataUrl, token);
        } else {
          console.error("Failed to capture screenshot");
        }
      });
    } else if (info.menuItemId === "selectAreaAndSendScreenshot") {
      // Workaround to get the system prompt in the background script
      chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" }, (dataUrl) => {
        if (dataUrl) {
          chrome.scripting.executeScript({
            target: { tabId: tab.id },
            function: injectScreenshotCode,
            args: [dataUrl, token]
          });
        } else {
          console.error("Failed to capture screenshot");
        }
      });
    }
    // ... other menu item handlers ...
  } catch (error) {
    console.error("Error fetching Google access token or sending data:", error);
  
    }
  
});

async function getGoogleAccessToken() {
  return new Promise((resolve, reject) => {
    chrome.cookies.get({ url: "http://localhost:3000", name: "googleAccessToken" }, (cookie) => {
      console.log(cookie);
      if (cookie) {
        resolve(cookie.value);
      } else {
        resolve(null);
      }
    });
  });
}

function sendTextToServer(text, token) {
  fetch("http://localhost:3001/text", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ text })
  })
  .then(response => response.text())
  .then(data => console.log("Text sent successfully:", data))
  .catch(error => console.error("Error sending text to server:", error));
}

function sendImageToServer(imageUrl, token) {
  fetch("http://localhost:3001/image", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ imageUrl })
  })
  .then(response => response.text())
  .then(data => console.log("Image sent successfully:", data))
  .catch(error => console.error("Error sending image to server:", error));
}

function sendScreenshotToServer(dataUrl, token) {
  fetch("http://localhost:3001/screenshot", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ screenshot: dataUrl })
  })
  .then(response => response.text())
  .then(data => console.log("Screenshot sent successfully:", data))
  .catch(error => console.error("Error sending screenshot to server:", error));
}

function injectScreenshotCode(dataUrl, token) {
  let canvas, ctx, startX, startY, endX, endY, isDrawing = false;
  const zoomFactor = 0.67;  

  function initializeScreenshotSelection(dataUrl, token) {
    canvas = document.createElement('canvas');
    document.body.style.zoom = `${zoomFactor * 100}%`;  
    const scale = window.devicePixelRatio;
    ctx = canvas.getContext('2d');
    ctx.scale(scale, scale);

    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.right = '0';
    canvas.style.bottom = '0';
    canvas.style.zIndex = '10000';
    
    document.body.appendChild(canvas);

    const img = new Image();
    img.onload = () => {
      canvas.width = img.width;
      canvas.height = img.height;
      ctx.drawImage(img, 0, 0);

      canvas.onmousedown = (e) => {
        startX = e.clientX / zoomFactor;  // Adjust for zoom
        startY = e.clientY / zoomFactor;  // Adjust for zoom
        isDrawing = true;
      };

      canvas.onmousemove = (e) => {
        if (isDrawing) {
          ctx.clearRect(0, 0, canvas.width, canvas.height);
          ctx.drawImage(img, 0, 0);
          endX = e.clientX / zoomFactor;  // Adjust for zoom
          endY = e.clientY / zoomFactor;  // Adjust for zoom
          ctx.strokeStyle = 'red';
          ctx.lineWidth = 2;
          ctx.strokeRect(startX, startY, endX - startX, endY - startY);
        }
      };

      canvas.onmouseup = () => {
        isDrawing = false;
        const croppedImage = ctx.getImageData(
          Math.min(startX, endX),
          Math.min(startY, endY),
          Math.abs(endX - startX),
          Math.abs(endY - startY)
        );
        canvas.onmousedown = canvas.onmousemove = canvas.onmouseup = null;

        let tempCanvas = document.createElement('canvas');
        tempCanvas.width = croppedImage.width;
        tempCanvas.height = croppedImage.height;
        let tempCtx = tempCanvas.getContext('2d');
        tempCtx.putImageData(croppedImage, 0, 0);

        const screenshotDataUrl = tempCanvas.toDataURL('image/png');
        sendScreenshotToServer(screenshotDataUrl, token);
        
        document.body.removeChild(canvas);
        document.body.style.zoom = "100%";  // Reset zoom to 100%
      };
    };
    img.src = dataUrl;
  }

  function sendScreenshotToServer(screenshotDataUrl, token) {
    fetch("http://localhost:3001/screenshot", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ screenshot: screenshotDataUrl })
    })
    .then(response => response.text())
    .then(data => {
      console.log("Screenshot sent successfully:", data);
    })
    .catch(error => console.error("Error sending screenshot to server:", error));
  }

  initializeScreenshotSelection(dataUrl, token);
}
