/*global fetch*/
document.addEventListener('DOMContentLoaded', () => {
  const loadMoreLink = document.getElementById('load-more');
  if (loadMoreLink) {
    loadMoreLink.addEventListener('click', (event) => {
      event.preventDefault();
      fetch(event.target.href, {
        headers: {
          'Accept': 'text/javascript'
        }
      })
      .then(response => response.text())
      .then(html => {
        const documentFragment = document.createRange().createContextualFragment(html);
        const newContent = documentFragment.querySelector('.video-list');
        const newLoadMoreLink = documentFragment.querySelector('.load-more-link');
        document.querySelector('.video-list').appendChild(newContent);
        if (newLoadMoreLink) {
          loadMoreLink.href = newLoadMoreLink.href;
        } else {
          loadMoreLink.remove();
        }
      });
    });
  }
});
