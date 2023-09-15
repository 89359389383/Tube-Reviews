# spec/features/favorites_spec.rb

require 'rails_helper'

RSpec.feature "Favorites", type: :feature do
  let(:user) { create(:user) } # 事前にUserモデルのFactoryBotを定義しておく必要があります。
  let(:video) { create(:video) } # 事前にVideoモデルのFactoryBotを定義しておく必要があります。

  before do
    # テストユーザーでログインする
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario "User adds a video to favorites from the video playback page" do
    visit video_path(video)

    expect {
      click_on 'Add to Favorites'
    }.to change(user.favorites, :count).by(1)

    expect(page).to have_content 'Video added to favorites!'
  end

  scenario "User removes a video from favorites on the favorites page" do
    # お気に入りに追加
    user.favorites.create(video: video)
    visit favorites_path

    expect {
      click_on 'Remove from Favorites'
    }.to change(user.favorites, :count).by(-1)

    expect(page).to have_content 'Video removed from favorites!'
  end

  scenario "User sees only their favorited videos on the favorites page" do
    user_favorite_video = create(:video)
    other_user = create(:user)
    other_favorite_video = create(:video)

    user.favorites.create(video: user_favorite_video)
    other_user.favorites.create(video: other_favorite_video)

    visit favorites_path

    expect(page).to have_content user_favorite_video.title
    expect(page).not_to have_content other_favorite_video.title
  end
end
