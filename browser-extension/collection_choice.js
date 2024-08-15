// collection_choice.js
document.addEventListener('DOMContentLoaded', function() {
    const select = document.getElementById('collectionSelect');
    const submitButton = document.getElementById('submitButton');
  
    chrome.storage.sync.get(['collections', 'defaultCollection'], (result) => {
      const collections = result.collections || ['Work', 'Personal', 'Study'];
      const defaultCollection = result.defaultCollection || collections[0];
  
      collections.forEach(collection => {
        const option = document.createElement('option');
        option.value = option.textContent = collection;
        select.appendChild(option);
      });
  
      select.value = defaultCollection;
    });
  
    submitButton.addEventListener('click', function() {
      const selectedCollection = select.value;
      chrome.runtime.sendMessage({
        type: 'collectionChosen',
        collection: selectedCollection
      });
      window.close();
    });
  });