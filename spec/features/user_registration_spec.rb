require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario "User can register with valid details" do
    visit new_user_registration_path

    fill_in I18n.t('devise.registrations.new.email'), with: 'test@example.com'
    fill_in I18n.t('devise.registrations.new.name'), with: 'Test User'
    fill_in I18n.t('devise.registrations.new.password'), with: 'password123'
    fill_in I18n.t('devise.registrations.new.password_confirmation'), with: 'password123'
    click_button I18n.t('devise.registrations.new.submit')

    expect(page).to have_content I18n.t('devise.registrations.user.signed_up', default: 'ユーザー登録が完了しました')
    expect(User.last.email).to eq 'test@example.com'
    expect(User.last.name).to eq 'Test User'
  end

  scenario "User cannot register with invalid details" do
    visit new_user_registration_path

    fill_in I18n.t('devise.registrations.new.email'), with: 'invalid-email'
    fill_in I18n.t('devise.registrations.new.name'), with: ''
    fill_in I18n.t('devise.registrations.new.password'), with: '123'
    fill_in I18n.t('devise.registrations.new.password_confirmation'), with: '321'
    click_button I18n.t('devise.registrations.new.submit')

    expect(page).to have_content I18n.t('errors.messages.not_saved', default: '保存に失敗しました')
    expect(User.count).to eq 0
  end
end
