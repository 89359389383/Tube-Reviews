require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'password123') }

  scenario "User logs in with valid details" do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    
    click_button 'Log in'
    
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario "User tries to log in with invalid details" do
    visit new_user_session_path
    
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'wrongpassword'
    
    click_button 'Log in'
    
    expect(page).to have_content 'Invalid Email or password.'
  end
end
