require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario "User registers with valid details" do
    visit new_user_registration_path
    
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Name', with: 'Test User'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    
    click_button 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "User tries to register with invalid details" do
    visit new_user_registration_path
    
    fill_in 'Email', with: 'test@example'
    fill_in 'Password', with: 'pass'
    fill_in 'Password confirmation', with: 'pass'
    
    click_button 'Sign up'
    
    # 期待するエラーメッセージに合わせて修正
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content 'Name is too short (minimum is 3 characters)'
  end
end
