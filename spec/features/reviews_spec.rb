require 'rails_helper'

RSpec.feature "Reviews", type: :feature do
  scenario "User can view reviews" do
    review1 = create(:review, title: "Title1")
    review2 = create(:review, title: "Title2")

    visit reviews_path

    expect(page).to have_content("Title1")
    expect(page).to have_content("Title2")
  end
end