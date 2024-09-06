// firebase.js
const admin = require('firebase-admin');

const { Storage } = require('@google-cloud/storage');

// Initialize the storage client
const storage = new Storage();

// Specify the bucket name
const bucketName = 'memocrize-5847e.appspot.com';

// Get the bucket object
const bucket = storage.bucket(bucketName);

var serviceAccount = require("../../memocrize-5847e-firebase-adminsdk-p4zl9-c9239337e8.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://memocrize-5847e-default-rtdb.firebaseio.com"
});

const db = admin.firestore();

module.exports = { admin, db, bucket };
