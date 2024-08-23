const express = require('express');
const app = express();
const cors = require('cors');
const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');

app.use(cors());
app.use(express.json({ limit: '50mb' }));

async function ensureDirectoryExistence(filePath) {
  const dirname = path.dirname(filePath);
  try {
    await fs.access(dirname);
  } catch (error) {
    await ensureDirectoryExistence(dirname);
    await fs.mkdir(dirname);
  }
}

async function ensureFileExistence(filePath) {
  try {
    await fs.access(filePath);
  } catch (error) {
    await fs.writeFile(filePath, '');
  }
}

app.post('/text', async (req, res) => {
  try {
    const { text, collection, mode } = req.body;
    console.log('Received text:', text);
    console.log('Collection:', collection);
    console.log('Mode:', mode);

    let baseDir = mode === 'stack' ? path.join(__dirname, 'data', 'stack') : path.join(__dirname, 'data', collection);
    await ensureDirectoryExistence(baseDir);

    let filePath = path.join(baseDir, `${uuidv4()}.txt`);
    await ensureFileExistence(filePath);
    await fs.appendFile(filePath, text);

    res.json({ message: 'Text received and saved successfully!' });
  } catch (error) {
    console.error('Error saving text:', error);
    res.status(500).json({ message: 'Error saving text' });
  }
});

app.post('/image', async (req, res) => {
  try {
    const { imageUrl, collection, mode } = req.body;
    console.log('Received image URL:', imageUrl);
    console.log('Collection:', collection);
    console.log('Mode:', mode);

    let baseDir = mode === 'stack' ? path.join(__dirname, 'data', 'stack') : path.join(__dirname, 'data', collection);
    await ensureDirectoryExistence(baseDir);

    let filePath = path.join(baseDir, `${uuidv4()}.jpg`);
    await ensureFileExistence(filePath);

    // Here you would implement the logic to download and save the image
    // For example:
    // await downloadImage(imageUrl, filePath);

    res.json({ message: 'Image URL received successfully!' });
  } catch (error) {
    console.error('Error processing image URL:', error);
    res.status(500).json({ message: 'Error processing image URL' });
  }
});

app.post('/screenshot', async (req, res) => {
  try {
    const { screenshot, collection, mode } = req.body;
    console.log(req.body);

    const base64Data = screenshot.replace(/^data:image\/png;base64,/, "");
 
    let baseDir = mode === 'stack' ? path.join(__dirname, 'data', 'stack') : path.join(__dirname, 'data', collection);
    // console.log(baseDir);
    await ensureDirectoryExistence(baseDir);

    let filePath = path.join(baseDir, `${uuidv4()}.png`);
   
    await ensureFileExistence(filePath);

    await fs.writeFile(filePath, base64Data, 'base64');

    console.log('Screenshot saved successfully:', filePath);
    res.json({ message: 'Screenshot received and saved successfully!' });
  } catch (error) {
    console.error('Error saving screenshot:', error);
    res.status(500).json({ message: 'Error saving screenshot' });
  }
});

app.listen(3001, () => {
  console.log('Server listening on port 3001');
});