/* global $ */ // この行を追加

document.addEventListener("turbolinks:load", function() {
  $('.favorite-toggle').on('click', function(e) {
    e.preventDefault();

    let videoId = $(this).data('video-id');
    let status = $(this).data('status');

    if (status === "favorited") {
      // お気に入り解除の処理
      $.ajax({
        url: `/videos/${videoId}/favorite`,
        type: 'DELETE',
        success: function() {
          $(`button[data-video-id="${videoId}"]`)
            .text("Add to Favorites")
            .data('status', '');
        }
      });
    } else {
      // お気に入り追加の処理
      $.ajax({
        url: `/videos/${videoId}/favorite`,
        type: 'POST',
        success: function() {
          $(`button[data-video-id="${videoId}"]`)
            .text("Remove from Favorites")
            .data('status', 'favorited');
        }
      });
    }
  });
});
