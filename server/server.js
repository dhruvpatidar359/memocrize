const express = require('express');
const app = express();
const cors = require('cors');
const fs = require('fs');
const path = require('path');

app.use(cors());
app.use(express.json({ limit: '50mb' }));

// Helper function to ensure directory exists
function ensureDirectoryExistence(filePath) {
  const dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) {
    return true;
  }
  ensureDirectoryExistence(dirname);
  fs.mkdirSync(dirname);
}

// Route to handle text data
app.post('/text', (req, res) => {
  const { text, collection, mode } = req.body;
  console.log('Received text:', text);
  console.log('Collection:', collection);
  console.log('Mode:', mode);

  const baseDir = path.join(__dirname, 'data', collection);
  ensureDirectoryExistence(baseDir);

  let filePath;
  if (mode === 'stack') {
    filePath = path.join(baseDir, `stack.txt`);
    fs.appendFileSync(filePath, text + '\n\n');
  } else {
    filePath = path.join(baseDir, `text-${Date.now()}.txt`);
    fs.writeFileSync(filePath, text);
  }

  res.json({ message: 'Text received and saved successfully!' });
});

// Route to handle image URLs
app.post('/image', (req, res) => {
  const { imageUrl, collection, mode } = req.body;
  console.log('Received image URL:', imageUrl);
  console.log('Collection:', collection);
  console.log('Mode:', mode);

  // Here you would implement the logic to download and save the image
  // For now, we'll just send a success message
  res.json({ message: 'Image URL received successfully!' });
});

// Route to handle screenshot data
app.post('/screenshot', (req, res) => {
  const { screenshot, collection, mode } = req.body;
  const base64Data = screenshot.replace(/^data:image\/png;base64,/, "");

  const baseDir = path.join(__dirname, 'data', collection, 'screenshots');
  ensureDirectoryExistence(baseDir);

  let filePath;
  if (mode === 'stack') {
    filePath = path.join(baseDir, `latest.png`);
  } else {
    filePath = path.join(baseDir, `screenshot-${Date.now()}.png`);
  }

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

app.listen(3001, () => {
  console.log('Server listening on port 3001');
});