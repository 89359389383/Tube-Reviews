# spec/features/video_interaction_spec.rb

require 'rails_helper'

RSpec.feature "VideoInteractions", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  before do
    # ログイン
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario "ユーザーが動画を検索する" do
    # 動画検索
    visit search_videos_path
    fill_in 'search_query', with: 'テスト'
    click_button '検索'

    # 検索結果が表示されることを確認
    expect(page).to have_content 'テストの動画タイトル'
  end

  scenario "ユーザーが動画の詳細を閲覧し、レビューを追加する" do
    video = FactoryBot.create(:video) # テスト用の動画データを作成

    # 動画詳細ページにアクセス
    visit video_path(video)

    # レビューを追加
    fill_in 'review_body', with: 'とても良い動画でした！'
    click_button '感想を投稿する'

    # レビューが表示されることを確認
    expect(page).to have_content 'とても良い動画でした！'
  end
end
