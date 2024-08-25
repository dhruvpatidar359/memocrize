const admin = require('firebase-admin'); // Import admin from Firebase Admin SDK

const { db, bucket } = require('../utils/firebase/firebase');
const { v4: uuidv4 } = require('uuid');
// const textToImage = require('some-text-to-image-lib'); // Replace with the actual library

const uploadImage = async (req, res) => {
    const { base64Image, collectionName, userId } = req.body;

    if (!base64Image || !collectionName || !userId) {
        return res.status(400).send("Incomplete Data");
    }

    const base64Data = base64Image.replace(/^data:image\/\w+;base64,/, "");
    const buffer = Buffer.from(base64Data, 'base64');
    const uniqueFileName = `${uuidv4()}`;
    const file = bucket.file(uniqueFileName);

    try {
        await file.save(buffer, {
            metadata: {
                contentType: 'image/jpeg'
            },
            public: false,
        });

        const fileUrl = `https://storage.googleapis.com/${bucket.name}/${uniqueFileName}`;

        // Store metadata in Firestore
        const imageCollection = db.collection('users').doc(userId);
        const userImage = imageCollection.collection(collectionName);

        const snapshot = await userImage.get();
        const count = snapshot.size; 

        const userImageCollection = userImage.doc(count.toString());

        await userImageCollection.set({
            fileName: uniqueFileName,
            fileUrl: fileUrl,
            uploadTimestamp: admin.firestore.FieldValue.serverTimestamp(), // Correct usage
        });

        return res.send({ fileUrl });
    } catch (error) {
        console.log(error);
        return res.status(500).send('Failed to upload image');
    }
}

const uploadText = async (req, res) => {
    const { text, collectionName, userId } = req.body;

    if (!text || !collectionName || !userId) {
        return res.status(400).send("Missing data");
    }

    const imageBuffer = textToImage(text, {
        width: 800,
        height: 400,
        fontSize: 60,
        bgColor: '#ffffff',
        textColor: '#000000',
    });

    const uniqueFileName = `${uuidv4()}-text-image.png`;
    const file = bucket.file(uniqueFileName);

    try {
        await file.save(imageBuffer, {
            metadata: { contentType: 'image/jpeg' },
            public: false,
        });

        const fileUrl = `https://storage.googleapis.com/${bucket.name}/${uniqueFileName}`;

        // Store metadata in Firestore
        const userRef = db.collection('users').doc(userId);
        const imageRef = userRef.collection(`${collectionName}`).doc();

        await imageRef.set({
            fileName: uniqueFileName,
            fileUrl: fileUrl,
            uploadTimestamp: admin.firestore.FieldValue.serverTimestamp(), // Correct usage
        });

        res.send({ fileUrl });
    } catch (error) {
        res.status(500).send('Failed to upload image');
    }
}

module.exports = { uploadImage, uploadText };
