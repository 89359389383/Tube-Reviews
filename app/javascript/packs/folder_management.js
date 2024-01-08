/*global Option*/
/*global fetch*/
document.addEventListener("turbolinks:load", () => {
  const reviewForm = document.getElementById('new_review');
  const folderSelect = document.getElementById('review_folder_id');
  const newFolderInput = document.getElementById('review_new_folder_name');

  // 新しいフォルダの追加
  reviewForm.addEventListener('submit', (e) => {
    const newFolderName = newFolderInput.value;
    if (newFolderName) {
      const newOption = new Option(newFolderName, newFolderName, false, true);
      folderSelect.appendChild(newOption);
    }
  });

  // フォルダ削除ボタンのイベントリスナーを追加
  document.querySelectorAll('.delete-folder-btn').forEach(button => {
    button.addEventListener('click', event => {
      event.preventDefault();
      const folderId = button.getAttribute('data-folder-id');
      if (folderId && confirm('このフォルダを削除しますか？')) {
        deleteFolder(folderId, button);
      }
    });
  });

  function deleteFolder(folderId, button) {
    const token = document.querySelector('[name=csrf-token]').content;
    fetch(`/folders/${folderId}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': token
      }
    }).then(response => {
      if (response.ok) {
        // DOMから該当するフォルダを削除
        button.parentElement.remove();
        // ドロップダウンからもフォルダを削除
        const optionToRemove = folderSelect.querySelector(`option[value="${folderId}"]`);
        if (optionToRemove) {
          optionToRemove.remove();
        }
      } else {
        alert('フォルダの削除に失敗しました');
      }
    });
  }
});

