// Initialize Firebase (you'll need to add your Firebase config here)
import { initializeApp } from 'firebase/app';
import { getStorage, ref, uploadString, uploadBytes } from 'firebase/storage';

const firebaseConfig = {
  // Your Firebase config here
};

const app = initializeApp(firebaseConfig);
const storage = getStorage(app);

// Create context menu items
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "saveText",
    title: "Save selected text",
    contexts: ["selection"]
  });

  chrome.contextMenus.create({
    id: "saveScreenshot",
    title: "Save screenshot",
    contexts: ["page"]
  });
});

// Handle context menu clicks
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "saveText") {
    saveTextToFirebase(info.selectionText);
  } else if (info.menuItemId === "saveScreenshot") {
    chrome.tabs.captureVisibleTab(null, {format: "png"}, (dataUrl) => {
      saveScreenshotToFirebase(dataUrl);
    });
  }
});

function saveTextToFirebase(text) {
  chrome.storage.sync.get("accessToken", (data) => {
    const accessToken = data.accessToken;
    if (!accessToken) {
      console.error("No access token found");
      return;
    }

    const textRef = ref(storage, `texts/${Date.now()}.txt`);
    uploadString(textRef, text).then((snapshot) => {
      console.log('Text uploaded successfully');
    }).catch((error) => {
      console.error('Error uploading text:', error);
    });
  });
}

function saveScreenshotToFirebase(dataUrl) {
  chrome.storage.sync.get("accessToken", (data) => {
    const accessToken = data.accessToken;
    if (!accessToken) {
      console.error("No access token found");
      return;
    }

    const screenshotRef = ref(storage, `screenshots/${Date.now()}.png`);
    fetch(dataUrl)
      .then(res => res.blob())
      .then(blob => {
        uploadBytes(screenshotRef, blob).then((snapshot) => {
          console.log('Screenshot uploaded successfully');
        }).catch((error) => {
          console.error('Error uploading screenshot:', error);
        });
      });
  });
}