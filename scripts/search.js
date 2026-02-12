(function () {
  var input = document.getElementById('mineral-search');
  var grid = document.getElementById('mineral-grid');
  var noResults = document.getElementById('no-results');
  var chips = document.querySelectorAll('.filter-chip');
  var cards = grid.querySelectorAll('.mineral-card');

  var activeFilter = 'all';
  var debounceTimer;

  function filterCards() {
    var query = input.value.trim().toLowerCase();
    var visible = 0;

    cards.forEach(function (card) {
      var name = card.getAttribute('data-name') || '';
      var cls = card.getAttribute('data-class') || '';
      var tags = card.getAttribute('data-tags') || '';
      var text = name + ' ' + cls + ' ' + tags;

      var matchesFilter = activeFilter === 'all' || cls === activeFilter;
      var matchesSearch = !query || text.indexOf(query) !== -1;

      if (matchesFilter && matchesSearch) {
        card.hidden = false;
        visible++;
      } else {
        card.hidden = true;
      }
    });

    noResults.hidden = visible > 0;
  }

  input.addEventListener('input', function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(filterCards, 150);
  });

  chips.forEach(function (chip) {
    chip.addEventListener('click', function () {
      chips.forEach(function (c) { c.classList.remove('active'); });
      chip.classList.add('active');
      activeFilter = chip.getAttribute('data-filter');
      filterCards();
    });
  });
})();
