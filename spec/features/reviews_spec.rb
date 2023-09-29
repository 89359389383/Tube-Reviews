require 'rails_helper'

RSpec.feature "Reviews", type: :feature do
  let(:user) { create(:user) }
  let!(:review1) { create(:review, :title1, user: user, created_at: 2.days.ago) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  scenario "User can filter reviews by title" do
    visit reviews_path

    # 検索ボックスの入力とボタンクリック
    fill_in 'search', with: 'Title1'
    click_button '検索'

    # ページの内容をログとして出力（デバッグ用）
    puts page.body

    # 期待する内容がページに表示されているかを確認
    expect(page).to have_content("Title1")
  end
end
