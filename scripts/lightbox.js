(function () {
  var overlay = document.getElementById('lightbox');
  if (!overlay) return;

  var img = overlay.querySelector('img');
  var btnClose = overlay.querySelector('.lightbox-close');
  var btnPrev = overlay.querySelector('.lightbox-prev');
  var btnNext = overlay.querySelector('.lightbox-next');

  var images = Array.prototype.slice.call(
    document.querySelectorAll('.mineral-gallery img')
  );
  var current = 0;

  function open(index) {
    current = index;
    img.src = images[current].src;
    img.alt = images[current].alt;
    overlay.classList.add('open');
    document.body.style.overflow = 'hidden';
    updateNav();
  }

  function close() {
    overlay.classList.remove('open');
    document.body.style.overflow = '';
  }

  function prev() {
    if (current > 0) {
      current--;
      img.src = images[current].src;
      img.alt = images[current].alt;
      updateNav();
    }
  }

  function next() {
    if (current < images.length - 1) {
      current++;
      img.src = images[current].src;
      img.alt = images[current].alt;
      updateNav();
    }
  }

  function updateNav() {
    btnPrev.style.display = current > 0 ? '' : 'none';
    btnNext.style.display = current < images.length - 1 ? '' : 'none';
  }

  images.forEach(function (galleryImg, i) {
    galleryImg.addEventListener('click', function () {
      open(i);
    });
  });

  btnClose.addEventListener('click', close);
  btnPrev.addEventListener('click', prev);
  btnNext.addEventListener('click', next);

  overlay.addEventListener('click', function (e) {
    if (e.target === overlay) {
      close();
    }
  });

  document.addEventListener('keydown', function (e) {
    if (!overlay.classList.contains('open')) return;

    if (e.key === 'Escape') {
      close();
    } else if (e.key === 'ArrowLeft') {
      prev();
    } else if (e.key === 'ArrowRight') {
      next();
    }
  });
})();
