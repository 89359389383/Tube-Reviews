# spec/controllers/reviews_controller_spec.rb
require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  let(:valid_review_attributes) { { title: "Sample title", body: "Great video!", video_id: video.id } }
  let(:invalid_review_attributes) { { title: "", body: "", video_id: video.id } }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all reviews as @reviews" do
      review = create(:review, user: user)
      get :index
      expect(assigns(:reviews)).to eq([review])
    end
  end

  describe "GET #show" do
    let(:review) { create(:review, user: user, video: video) }

    it "assigns the requested review as @review" do
      get :show, params: { video_id: review.video_id, id: review.id }
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "POST #create" do
    context "with valid data" do
      it "saves the new review and redirects to the review index" do
        expect {
          post :create, params: { video_id: video.id, review: valid_review_attributes }
        }.to change(Review, :count).by(1)
        expect(Review.last.title).to eq("Sample title")
        expect(Review.last.body).to eq("Great video!")
        expect(response).to redirect_to reviews_path
        expect(flash[:notice]).to eq("感想を投稿しました")
      end
    end
    
    context "with invalid data" do
      it "does not save the review and renders the new action" do
        expect {
          post :create, params: { video_id: video.id, review: invalid_review_attributes }
        }.not_to change(Review, :count)
        expect(flash[:alert]).to include("Body can't be blank")
        expect(flash[:alert]).to include("Body is too short (minimum is 5 characters)")
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    let!(:review) { create(:review, user: user, video: video) }

    context "with valid data" do
      let(:new_attributes) { { title: "Updated title", body: "Updated body!" } }

      it "updates the review and redirects to the review index" do
        patch :update, params: { video_id: review.video_id, id: review.id, review: new_attributes }
        review.reload
        expect(review.title).to eq("Updated title")
        expect(review.body).to eq("Updated body!")
        expect(response).to redirect_to reviews_path
        expect(flash[:notice]).to eq("感想を更新しました")
      end
    end

    context "with invalid data" do
      it "does not update the review and renders the edit action" do
        patch :update, params: { video_id: review.video_id, id: review.id, review: invalid_review_attributes }
        review.reload
        expect(review.title).not_to eq("")
        expect(flash[:alert]).to include("Body can't be blank")
        expect(flash[:alert]).to include("Body is too short (minimum is 5 characters)")
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:review) { create(:review, user: user, video: video) }

    it "deletes the review and redirects to the review index" do
      expect {
        delete :destroy, params: { video_id: review.video_id, id: review.id }
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to reviews_path
      expect(flash[:notice]).to eq("感想が正常に削除されました")
    end
  end
end

