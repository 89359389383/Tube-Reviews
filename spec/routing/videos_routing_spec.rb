require "rails_helper"

RSpec.describe VideosController, type: :routing do
  it "routes to #index" do
    expect(get: "/videos").to route_to("videos#index")
  end

  it "routes to #new" do
    expect(get: "/videos/new").to route_to("videos#new")
  end

  # 他のアクションに関するルーティングも同様にテストを追加します。
end
