# spec/views/your_view_spec.rb
require 'rails_helper'

RSpec.describe "your_view", type: :view do
  it "renders the social share buttons" do
    render
    expect(rendered).to have_selector('.social-share-button')
  end
end
