require 'rails_helper'

RSpec.describe "videos/index", type: :view do
  it "displays the correct video list" do
    assign(:videos, [create(:video, title: "Video1"), create(:video, title: "Video2")])
  
    render

    expect(rendered).to match /Video1/
    expect(rendered).to match /Video2/
  end
end
