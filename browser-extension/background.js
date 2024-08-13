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
    contexts: ["all"] // 'all' context so it's always available
  });

  chrome.contextMenus.create({
    id: "selectAreaAndSendScreenshot",
    title: "Select area and send screenshot",
    contexts: ["all"]
  });
});

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
      chrome.desktopCapture.chooseDesktopMedia(["screen", "window"], tab, async (streamId) => {
        if (!streamId) {
          console.error("Failed to get stream ID");
          return;
        }

        const captureOptions = {
          video: {
            mandatory: {
              chromeMediaSource: "desktop",
              chromeMediaSourceId: streamId,
            },
          },
        };

        try {
          const stream = await navigator.mediaDevices.getUserMedia(captureOptions);
          const track = stream.getVideoTracks()[0];
          const imageCapture = new ImageCapture(track);
          const bitmap = await imageCapture.grabFrame();
          track.stop();

          chrome.tabs.create({
            url: chrome.runtime.getURL("capture.html"),
            active: false
          }, function (tab) {
            chrome.tabs.onUpdated.addListener(function listener(tabId, info) {
              if (info.status === "complete" && tabId === tab.id) {
                chrome.tabs.onUpdated.removeListener(listener);
                chrome.tabs.sendMessage(tab.id, { bitmap, token });
              }
            });
          });

        } catch (error) {
          console.error("Error capturing the screen:", error);
        }
      });
    }
  } catch (error) {
    console.error("Error fetching Google access token or sending data:", error);
  }
});

async function getGoogleAccessToken() {
  return new Promise((resolve, reject) => {
    chrome.cookies.get({ url: "http://localhost:3000", name: "googleAccessToken" }, (cookie) => {
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
