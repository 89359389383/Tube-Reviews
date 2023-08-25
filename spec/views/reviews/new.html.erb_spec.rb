require 'rails_helper'

RSpec.describe "reviews/new", type: :view do
  it "renders the review form" do
    assign(:review, build(:review))

    render

    expect(rendered).to have_selector("form")
    # you can also check for specific fields, like:
    expect(rendered).to have_selector("textarea[name='review[content]']")
  end

  it "shows validation messages" do
    review = build(:review, content: "")
    review.valid?
    assign(:review, review)

    render

    expect(rendered).to match /Content can't be blank/
  end
end