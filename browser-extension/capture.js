let canvas, ctx, startX, startY, endX, endY, isDrawing = false;


chrome.runtime.onConnect.addListener(function(port) {
  console.log('Content script connected');
});

chrome.runtime.sendMessage({action: "contentScriptReady"}, function(response) {
  console.log('Content script reported as ready');
});


chrome.runtime.onMessage.addListener((message) => {
  
  if (message.action === "initializeScreenshotSelection" && message.dataUrl && message.token) {
    initializeScreenshotSelection(message.dataUrl, message.token);
  }
});

function initializeScreenshotSelection(dataUrl, token) {
  canvas = document.createElement('canvas');
  ctx = canvas.getContext('2d');
  
  canvas.style.position = 'fixed';
  canvas.style.top = '0';
  canvas.style.left = '0';
  canvas.style.zIndex = '10000';
  
  document.body.appendChild(canvas);

  const img = new Image();
  img.onload = () => {
    canvas.width = img.width;
    canvas.height = img.height;
    ctx.drawImage(img, 0, 0);

    canvas.onmousedown = (e) => {
      startX = e.clientX;
      startY = e.clientY;
      isDrawing = true;
    };

    canvas.onmousemove = (e) => {
      if (isDrawing) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, 0, 0);
        endX = e.clientX;
        endY = e.clientY;
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

      const dataUrl = tempCanvas.toDataURL('image/png');
      sendScreenshotToServer(dataUrl, token);
      
      document.body.removeChild(canvas);
    };
  };
  img.src = dataUrl;
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
  .then(data => {
    console.log("Screenshot sent successfully:", data);
  })
  .catch(error => console.error("Error sending screenshot to server:", error));
}