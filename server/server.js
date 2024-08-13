const express = require('express');
const app = express();
const cors = require('cors');
const fs = require('fs');
const path = require('path');

// Enable CORS for all origins
app.use(cors());

// Enable parsing of JSON request bodies
app.use(express.json({ limit: '50mb' })); // Increase the limit for large screenshots

// Route to handle text data
app.post('/text', (req, res) => {
  const text = req.body.text;
  console.log('Received text:', text);
  res.json({ message: 'Text received successfully!' });
});

// Route to handle image URLs
app.post('/image', (req, res) => {
  const imageUrl = req.body.imageUrl;
  console.log('Received image URL:', imageUrl);
  // Here you can download the image using the URL or process it as needed
  res.json({ message: 'Image URL received successfully!' });
});

// Route to handle screenshot data
app.post('/screenshot', (req, res) => {
  const screenshotData = req.body.screenshot;
  const base64Data = screenshotData.replace(/^data:image\/png;base64,/, "");
  const filePath = path.join(__dirname, 'screenshots', `screenshot-${Date.now()}.png`);

  // Save the screenshot as a file
  fs.writeFile(filePath, base64Data, 'base64', (err) => {
    if (err) {
      console.error('Error saving screenshot:', err);
      res.status(500).json({ message: 'Error saving screenshot' });
    } else {
      console.log('Screenshot saved successfully:', filePath);
      res.json({ message: 'Screenshot received and saved successfully!' });
    }
  });
});

// Start the server on port 3001
app.listen(3001, () => {
  console.log('Server listening on port 3001');
});
