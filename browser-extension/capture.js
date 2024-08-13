let canvas = document.getElementById('canvas');
let ctx = canvas.getContext('2d');

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

let startX, startY, endX, endY, isDrawing = false;

chrome.runtime.onMessage.addListener((message) => {
  if (message.bitmap && message.token) {
    const bitmap = message.bitmap;

    // Draw the captured screen on the canvas
    createImageBitmap(bitmap).then(imgBitmap => {
      ctx.drawImage(imgBitmap, 0, 0, canvas.width, canvas.height);
    });

    // Mouse down to start selecting the area
    canvas.onmousedown = (e) => {
      startX = e.clientX;
      startY = e.clientY;
      isDrawing = true;
    };

    // Mouse move to update the selected area
    canvas.onmousemove = (e) => {
      if (isDrawing) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(bitmap, 0, 0, canvas.width, canvas.height);
        endX = e.clientX;
        endY = e.clientY;
        ctx.strokeStyle = 'red';
        ctx.lineWidth = 2;
        ctx.strokeRect(startX, startY, endX - startX, endY - startY);
      }
    };

    // Mouse up to finish selecting and send the cropped area
    canvas.onmouseup = () => {
      isDrawing = false;
      const croppedImage = ctx.getImageData(startX, startY, endX - startX, endY - startY);
      canvas.onmousedown = canvas.onmousemove = canvas.onmouseup = null;

      // Create a temporary canvas to hold the cropped image
      let tempCanvas = document.createElement('canvas');
      tempCanvas.width = croppedImage.width;
      tempCanvas.height = croppedImage.height;
      let tempCtx = tempCanvas.getContext('2d');
      tempCtx.putImageData(croppedImage, 0, 0);

      // Convert to data URL and send to server
      tempCanvas.toDataURL('image/png').then(dataUrl => {
        sendScreenshotToServer(dataUrl, message.token);
      });
    };
  }
});

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
    window.close(); // Close the tab after sending
  })
  .catch(error => console.error("Error sending screenshot to server:", error));
}
