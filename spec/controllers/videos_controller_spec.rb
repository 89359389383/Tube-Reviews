require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video, title: "Test Video") }

  before { sign_in user }

  describe "GET #index" do
    let!(:videos) { create_list(:video, 2) }

    it "assigns all videos to @videos and renders the :index template" do
      get :index
      expect(assigns(:videos)).to match_array(videos)
      expect(response).to render_template :index
    end
  end

  describe "GET #search" do
    context "with valid search query" do
      before { get :search, params: { search_query: "Test" } }

      it "assigns the search results to @videos" do
        expect(assigns(:videos)).to include(video)
      end

      it "renders the :index template" do
        expect(response).to render_template :index
      end
    end

    context "with empty search query" do
      before { get :search }

      it "does not assign any videos to @videos" do
        expect(assigns(:videos)).to be_empty
      end
    end
  end

  describe "GET #show" do
    context "with an existing video in database" do
      let(:video) { create(:video) }

      it "assigns the requested video to @video" do
        get :show, params: { id: video.id }
        expect(assigns(:video)).to eq(video)
      end
    end

    context "with a video not in the database" do
      let(:mock_video) { build(:video, video_id: "sample_video_id_8") }

      before do
        allow(YoutubeService).to receive(:fetch_video_details_by_id).and_return(mock_video)
        get :show, params: { id: mock_video.video_id }
      end

      it "assigns the video from YouTube API to @video" do
        expect(assigns(:video).video_id).to eq(mock_video.video_id)
      end
    end
  end
end

