/* global $, fetch */

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
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert(`エラーが発生しました: ${errorThrown}`);
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
        },
        error: function(jqXHR, textStatus, errorThrown) {
          alert(`エラーが発生しました: ${errorThrown}`);
        }
      });
    }
  });

  // お気に入り動画の一覧取得
  fetchFavorites();
});

async function fetchFavorites() {
  const videoListContainer = document.getElementById('video-list');
    
  try {
    const response = await fetch('/api/favorites');
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || 'Network response was not ok');
    }
    
    const data = await response.json();
    displayVideos(data, videoListContainer);
    
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error);
    alert('エラーが発生しました: ' + error.message);
  }
}

function displayVideos(videos, container) {
  videos.forEach(video => {
    const videoElement = document.createElement('div');
    videoElement.className = 'video-item';

    const thumbnail = document.createElement('img');
    thumbnail.src = video.thumbnailUrl;
    thumbnail.alt = video.title;
    videoElement.appendChild(thumbnail);

    const title = document.createElement('h2');
    title.textContent = video.title;
    videoElement.appendChild(title);

    const memo = document.createElement('p');
    memo.textContent = video.memo;
    videoElement.appendChild(memo);

    const registrationDate = document.createElement('p');
    registrationDate.textContent = `登録日: ${video.registrationDate}`;
    videoElement.appendChild(registrationDate);

    container.appendChild(videoElement);
  });
}

