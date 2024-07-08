# spec/features/user_login_spec.rb
require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'password123') }

  scenario "User logs in with valid details" do
    visit new_user_session_path

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content 'ユーザーとしてログインしました'
  end

  scenario "User tries to log in with invalid details" do
    visit new_user_session_path
    
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'wrongpassword'

    click_button 'ログイン'

    expect(page).to have_content 'メールアドレスまたはパスワードが正しくありません'
  end
end
