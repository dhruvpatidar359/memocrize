const { createCanvas, loadImage } = require('canvas');

function textToImage(text, options = {}) {
  const width = options.width || 800;
  const height = options.height || 200;
  const fontSize = options.fontSize || 50;
  const bgColor = options.bgColor || '#ffffff';
  const textColor = options.textColor || '#000000';
  const fontFamily = options.fontFamily || 'Arial';

  const canvas = createCanvas(width, height);
  const ctx = canvas.getContext('2d');

  // Set background color
  ctx.fillStyle = bgColor;
  ctx.fillRect(0, 0, width, height);

  // Set text style
  ctx.fillStyle = textColor;
  ctx.font = `${fontSize}px ${fontFamily}`;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';

  // Draw the text
  ctx.fillText(text, width / 2, height / 2);

  return canvas.toBuffer('image/png');
}

module.exports = textToImage;
