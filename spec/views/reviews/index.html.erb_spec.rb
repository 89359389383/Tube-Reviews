# spec/views/reviews/index.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      create(:review, title: "Title1"),
      create(:review, title: "Title2")
    ])
  end

  it "renders a list of reviews" do
    render
    assert_select "tr>td", text: "Title1".to_s, count: 1
    assert_select "tr>td", text: "Title2".to_s, count: 1
  end
end