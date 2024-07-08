require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  let(:folder) { create(:folder, user: user) }
  let(:review) { create(:review, user: user, video: video, folder: folder) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { video_id: video.id, id: review.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) do
        { title: "Great video", body: "I enjoyed it", video_id: video.id, play_time: 120, folder_id: folder.id }
      end

      it "creates a new Review" do
        expect {
          post :create, params: { review: valid_attributes, video_id: video.id }
        }.to change(Review, :count).by(1)
      end

      it "redirects to the video show page" do
        post :create, params: { review: valid_attributes, video_id: video.id }
        expect(response).to redirect_to(video_path(video))
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) do
        { title: "", body: "", video_id: nil }
      end

      it "does not create a new Review" do
        expect {
          post :create, params: { review: invalid_attributes, video_id: video.id }
        }.not_to change(Review, :count)
      end

      it "renders the 'videos/show' template" do
        post :create, params: { review: invalid_attributes, video_id: video.id }
        expect(response).to render_template('videos/show')
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: review.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) do
        { title: "Updated review", body: "Updated body" }
      end

      it "updates the requested review" do
        patch :update, params: { id: review.id, review: new_attributes }
        review.reload
        expect(review.title).to eq("Updated review")
        expect(review.body).to eq("Updated body")
      end

      it "redirects to the reviews index" do
        patch :update, params: { id: review.id, review: new_attributes }
        expect(response).to redirect_to(reviews_path)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) do
        { title: "", body: "" }
      end

      it "does not update the review" do
        patch :update, params: { id: review.id, review: invalid_attributes }
        review.reload
        expect(review.title).not_to eq("")
        expect(review.body).not_to eq("")
      end

      it "renders the edit template" do
        patch :update, params: { id: review.id, review: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end
end
