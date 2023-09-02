// app/assets/javascripts/reviews.js
$(document).ready(function() {
  $('.delete-link').on('click', function(e) {
    e.preventDefault();
    if (confirm('削除してもよろしいですか？')) {
      window.location.href = $(this).attr('href');
    }
  });
});
