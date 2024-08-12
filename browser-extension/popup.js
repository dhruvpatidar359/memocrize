document.addEventListener('DOMContentLoaded', () => {
    const collectionList = document.getElementById('collectionList');
    const newCollectionInput = document.getElementById('newCollectionInput');
    const createCollectionBtn = document.getElementById('createCollectionBtn');
  
    // Load existing collections
    chrome.storage.sync.get('collections', (data) => {
      const collections = data.collections || [];
      renderCollections(collections);
    });
  
    // Create new collection
    createCollectionBtn.addEventListener('click', () => {
      const newCollection = newCollectionInput.value.trim();
      if (newCollection) {
        chrome.storage.sync.get('collections', (data) => {
          const collections = data.collections || [];
          collections.push(newCollection);
          chrome.storage.sync.set({ collections }, () => {
            renderCollections(collections);
            newCollectionInput.value = '';
          });
        });
      }
    });
  
    function renderCollections(collections) {
      collectionList.innerHTML = '';
      collections.forEach((collection) => {
        const li = document.createElement('li');
        li.textContent = collection;
        collectionList.appendChild(li);
      });
    }
  });