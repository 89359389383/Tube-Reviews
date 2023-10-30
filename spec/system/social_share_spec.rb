# spec/system/social_share_spec.rb
require 'rails_helper'

RSpec.describe "Social Share", type: :system do
  it "opens the social media share page when the share button is clicked" do
    visit your_page_path
    click_on "Share to social networks"
    # ここで新しく開かれたウィンドウに切り替える
    within_window(windows.last) do
      expect(current_url).to include("social_media_share_url")
    end
  end
end
