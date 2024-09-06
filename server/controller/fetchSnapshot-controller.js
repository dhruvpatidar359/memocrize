const { db } = require("../utils/firebase/firebase");

const fetchAllSubcollections = async (req, res) => {
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).send("Incomplete Data");
  }

  try {
    const docRef = db.collection('users').doc(userId);
    const collections = await docRef.listCollections();

    if (collections.length === 0) {
      console.log(`No subcollections for userID : ${userId}`);
      return res.status(400).send("No Subcollections Found");
    }

    const results = {};

    // Iterate through each subcollection and fetch documents
    for (const collection of collections) {
      const snapshot = await collection.get();
      const documents = [];

      snapshot.forEach(doc => {
        documents.push({ id: doc.id, data: doc.data() });
      });

      results[collection.id] = documents; // Store subcollection data in results
    }

    console.log(results);
    return res.status(200).json(results);
  } catch (error) {
    console.log(error);
    return res.status(400).send("Failed to fetch subcollections");
  }
};

module.exports = { fetchAllSubcollections };
