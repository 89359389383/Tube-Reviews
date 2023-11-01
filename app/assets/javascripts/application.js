//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require social-share-button

document.addEventListener("turbolinks:load", function() {
  try {
    // シェアボタンの初期化や設定に関するコード
    // 例: SocialShareButton.init();
  } catch (e) {
    console.error("シェアボタンの表示に失敗しました: ", e);
  }
});
