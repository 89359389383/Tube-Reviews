# spec/views/videos/show.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "videos/show", type: :view do
  let(:video) { create(:video, title: "Sample Video") }
  let(:reviews) { [create(:review, content: "Nice video!", video: video)] }

  it "displays video details correctly" do
    assign(:video, video)
    assign(:reviews, reviews)

    render

    expect(rendered).to match /Sample Video/
    expect(rendered).to have_selector("iframe") # assuming an iframe for the video player
    expect(rendered).to match /Nice video!/
  end
end

