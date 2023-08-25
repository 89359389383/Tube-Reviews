require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe "GET #index" do
    it "assigns all videos to @videos" do
      video1 = FactoryBot.create(:video)
      video2 = FactoryBot.create(:video)
      get :index
      expect(assigns(:videos)).to eq([video1, video2])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #search" do
    context "with valid search query" do
      # ここでYouTube APIのモックを追加するか、実際のビデオデータをデータベースに追加して検索結果をテストする
      
      it "assigns the search results to @videos" do
        video = FactoryBot.create(:video, title: "Test Video")
        get :search, params: { search_query: "Test" }
        expect(assigns(:videos)).to eq([video])
      end

      it "renders the :index template" do
        get :search, params: { search_query: "Test" }
        expect(response).to render_template :index
      end
    end

    context "with empty search query" do
      it "does not assign any videos to @videos" do
        get :search
        expect(assigns(:videos)).to eq([])
      end
    end
  end

  describe "GET #show" do
    context "with an existing video in database" do
      it "assigns the requested video to @video" do
        video = FactoryBot.create(:video)
        get :show, params: { id: video.id }
        expect(assigns(:video)).to eq(video)
      end

      # 必要に応じて他のテストも追加する
    end

    context "with a video not in the database" do
      # YouTube APIのモックを利用して、APIからの動画データをテストする
      
      # 必要に応じて他のテストも追加する
    end
  end
end