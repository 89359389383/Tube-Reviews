require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  
  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns @videos and renders the index template" do
      get :index
      expect(assigns(:videos)).to eq([video])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #search" do
    it "assigns @videos and renders the index template when search_query is present" do
      allow(YoutubeService).to receive(:search_videos).and_return({ items: [video], nextPageToken: 'next_token', prevPageToken: 'prev_token' })
      allow(YoutubeService).to receive(:filter_videos_by_duration).and_return([video])

      get :search, params: { search_query: 'test' }
      expect(assigns(:videos)).to eq([video])
      expect(response).to render_template(:index)
    end

    it "assigns @videos to none when search_query is not present" do
      get :search
      expect(assigns(:videos)).to be_empty
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "when video exists in the database" do
      it "assigns @video and renders the show template" do
        get :show, params: { id: video.id }
        expect(assigns(:video)).to eq(video)
        expect(response).to render_template(:show)
      end
    end

    context "when video does not exist in the database" do
      it "fetches video details and saves it to the database" do
        allow(YoutubeService).to receive(:fetch_video_details_by_id).and_return({ id: '123', title: 'Test Video', url: "https://www.youtube.com/watch?v=123" })

        get :show, params: { id: '123' }
        new_video = Video.find_by(url: "https://www.youtube.com/watch?v=123")
        expect(assigns(:video)).to eq(new_video)
        expect(response).to render_template(:show)
      end

      it "redirects to videos_path with an alert if video details are not found" do
        allow(YoutubeService).to receive(:fetch_video_details_by_id).and_return(nil)

        get :show, params: { id: 'invalid_id' }
        expect(flash[:alert]).to eq("動画が見つかりませんでした。")
        expect(response).to redirect_to(videos_path)
      end
    end
  end
end
