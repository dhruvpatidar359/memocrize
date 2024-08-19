


async function getUserCollectionChoice() {
  return new Promise((resolve) => {
    chrome.storage.sync.get(['collections', 'defaultCollection'], (result) => {
      const collections = result.collections || ['Work', 'Personal', 'Study'];
      

      console.log(collections);
      
      chrome.windows.create({
        url: chrome.runtime.getURL('collection_choice.html'),
        type: 'popup',
        
      }, (window) => {
        chrome.runtime.onMessage.addListener(function listener(message) {
          if (message.type === 'collectionChosen') {
            chrome.runtime.onMessage.removeListener(listener);
            chrome.windows.remove(window.id); // Close the window here
            resolve(message.collection);
          }
          console.log("received message", message);
        });
      });
    });
  });
}

// Function to get user's mode preference
async function getUserModePreference() {
  return new Promise((resolve) => {
    chrome.storage.sync.get('mode', (result) => {
      resolve(result.mode || 'collection');
    });
  });
}


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
  } else if (command === "sendTextToServer") {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
      let activeTab = tabs[0];
      sendSelectedTextToServer(activeTab);
    });
  } else if (command === "sendFullScreenShotToServer") {
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
      let activeTab = tabs[0];
      sendFullScreenshotToServer(activeTab);
    });
  } 
});

async function sendSelectedTextToServer(tab) {
  try {
    const token = await getGoogleAccessToken();
    
    if (!token) {
      console.log("No access token found. Redirecting to sign-in page.");
      chrome.tabs.create({ url: "http://localhost:3000/signin" });
      return;
    }
    console.log("worlking");
    const collection = await getUserCollectionChoice();
    console.log(collection);
    console.log("works");

    const mode = await getUserModePreference();

    console.log(collection);

    chrome.scripting.executeScript({
      target: { tabId: tab.id },
      function: getSelectedText,
    }, (results) => {
      if (chrome.runtime.lastError) {
        console.error("Error executing script:", chrome.runtime.lastError);
        return;
      }

      const selectedText = results[0].result;
      if (selectedText) {
        console.log("Selected text:", selectedText);
        sendTextToServer(selectedText, token, collection, mode);
      } else {
        console.log("No text selected");
      }
    });
  } catch (error) {
    console.error("Error in sendSelectedTextToServer:", error);
  }
}

function sendTextToServer(text, token, collection, mode) {
  console.log("Sending text to server:", text);
  fetch("http://localhost:3001/text", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ text, collection, mode })
  })
  .then(response => response.text())
  .then(data => console.log("Text sent successfully:", data))
  .catch(error => console.error("Error sending text to server:", error));
}

function getSelectedText() {
  console.log(window.getSelection().toString());
  return window.getSelection().toString();
}



async function initiateScreenshotCapture(tab)  {
  const collection = await getUserCollectionChoice();
  const mode = await getUserModePreference();

  console.log(collection);
  chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" },async (dataUrl) => {
    console.log("working boss");
    if (dataUrl) {
     
      const token = await getGoogleAccessToken();
      console.log(dataUrl,collection,mode,token);
      chrome.scripting.executeScript({
        target: { tabId: tab.id },
        function: injectScreenshotCode,
        args: [dataUrl, token,collection,mode] 
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
        sendSelectedTextToServer(tab);
      }
    } else if (info.menuItemId === "sendImage") {
      const imageUrl = info.srcUrl;
      if (imageUrl) {
        sendImageToServer(imageUrl, token);
      }
    } else if (info.menuItemId === "sendScreenshot") {
      chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" }, (dataUrl) => {
        if (dataUrl) {
          sendFullScreenshotToServer(tab);
        } else {
          console.error("Failed to capture screenshot");
        }
      });
    } else if (info.menuItemId === "selectAreaAndSendScreenshot") {
      initiateScreenshotCapture(tab);
    }
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

function sendScreenshotToServer(screenshotDataUrl, token, collection, mode) {
  console.log(screenshotDataUrl,collection);
  fetch("http://localhost:3001/screenshot", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ screenshot: screenshotDataUrl,collection : collection,mode: mode })
  })
  .then(response => response.text())
  .then(data => {
    console.log("Screenshot sent successfully:", data);
  })
  .catch(error => console.error("Error sending screenshot to server:", error));
}

 function injectScreenshotCode(dataUrl, token,collection,mode) {

  function sendScreenshotToServer(screenshotDataUrl, token, collection, mode) {
    console.log(screenshotDataUrl,collection);
    fetch("http://localhost:3001/screenshot", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ screenshot: screenshotDataUrl,collection : collection,mode: mode })
    })
    .then(response => response.text())
    .then(data => {
      console.log("Screenshot sent successfully:", data);
    })
    .catch(error => console.error("Error sending screenshot to server:", error));
  }
 
  let canvas, ctx, startX, startY, endX, endY, isDrawing = false;
  const zoomFactor = 0.67;  

   function initializeScreenshotSelection(dataUrl, token,collection,mode) {
   
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
        
    console.log(collection);
    console.log("bhai upper ha vo");
    console.log(mode);
        sendScreenshotToServer(screenshotDataUrl, token, collection, mode);
        
        document.body.removeChild(canvas);
        document.body.style.zoom = "100%";  // Reset zoom to 100%
      };
    };
    img.src = dataUrl;
  }

 

  initializeScreenshotSelection(dataUrl, token,collection,mode);
}

async function sendFullScreenshotToServer(tab) {
  try {
    const token = await getGoogleAccessToken();
    if (!token) {
      chrome.tabs.create({ url: "http://localhost:3000/signin" });
      return;
    }

    const collection = await getUserCollectionChoice();
    const mode = await getUserModePreference();

    chrome.tabs.captureVisibleTab(tab.windowId, { format: "png" }, (dataUrl) => {
      if (dataUrl) {
        sendScreenshotToServer(dataUrl, token, collection, mode);
      } else {
        console.error("Failed to capture screenshot");
      }
    });
  } catch (error) {
    console.error("Error fetching Google access token or sending full screenshot:", error);
  }
}

chrome.runtime.onInstalled.addListener(() => {
  chrome.commands.getAll(commands => {
    for (let command in commands) {
      console.log(`Command ${command} is registered:`, commands[command]);
    }
  });
});