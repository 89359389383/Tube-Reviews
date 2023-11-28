/* global Option */
document.addEventListener("turbolinks:load", () => {
  const reviewForm = document.getElementById('new_review'); // フォームのIDに合わせて変更してください
  const folderSelect = document.getElementById('review_folder_id'); // ドロップダウンメニューのIDに合わせて変更してください
  const newFolderInput = document.getElementById('review_new_folder_name'); // 新しいフォルダ名入力フィールドのIDに合わせてください

  reviewForm.addEventListener('submit', (e) => {
    const newFolderName = newFolderInput.value;
    if (newFolderName) {
      // 新しいフォルダをドロップダウンに追加
      const newOption = new Option(newFolderName, newFolderName, false, true);
      folderSelect.appendChild(newOption);
    }
  });
});
