document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.getElementById('searchInput');
  const sortSelect = document.getElementById('sortSelect');
  const collectionsGrid = document.getElementById('collectionsGrid');
  const submitButton = document.getElementById('submitButton');
  let collections = [];
  let selectedCollection = null;

  chrome.storage.sync.get(['collections', 'defaultCollection'], (result) => {
      collections = result.collections || ['Work', 'Personal', 'Study'];
      const defaultCollection = result.defaultCollection || collections[0];

      renderCollections(collections);
      selectCollection(defaultCollection);
  });

  function renderCollections(collectionsToRender) {
      collectionsGrid.innerHTML = '';
      collectionsToRender.forEach(collection => {
          const item = document.createElement('div');
          item.className = 'collection-item';
          item.innerHTML = `
              <i class="material-icons">folder</i>
              <span>${collection}</span>
          `;
          item.addEventListener('click', () => selectCollection(collection));
          collectionsGrid.appendChild(item);
      });
  }

  function selectCollection(collection) {
      selectedCollection = collection;
      document.querySelectorAll('.collection-item').forEach(item => {
          item.style.backgroundColor = item.querySelector('span').textContent === collection ? '#e8f0fe' : '';
      });
  }

  searchInput.addEventListener('input', () => {
      const searchTerm = searchInput.value.toLowerCase();
      const filteredCollections = collections.filter(collection => 
          collection.toLowerCase().includes(searchTerm)
      );
      renderCollections(filteredCollections);
  });

  sortSelect.addEventListener('change', () => {
      const sortedCollections = [...collections].sort((a, b) => {
          if (sortSelect.value === 'name') {
              return a.localeCompare(b);
          } else {
              // For 'recent', you would need to implement a way to track recent usage
              // This is just a placeholder sort
              return 0.5 - Math.random();
          }
      });
      renderCollections(sortedCollections);
  });

  submitButton.addEventListener('click', function() {
      if (selectedCollection) {
          chrome.runtime.sendMessage({
              type: 'collectionChosen',
              collection: selectedCollection
          });
      }
  });
});