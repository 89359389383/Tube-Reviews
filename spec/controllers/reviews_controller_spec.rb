# spec/controllers/reviews_controller_spec.rb
require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video) }

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

  describe "POST #create" do
    context "with valid data" do
      it "saves the new review" do
        post :create, params: { review: { title: "Sample title", body: "Great video!", video_id: video.id } }
        expect(Review.last.title).to eq("Sample title")
        expect(Review.last.body).to eq("Great video!")
      end
    end
    
    context "with invalid data" do
      it "displays an error message when body is missing" do
        post :create, params: { review: { title: "Sample title", body: "", video_id: video.id } }
        expect(flash[:alert]).to include("Body can't be blank")
      end

      # タイトルが不足している場合のテスト
      it "displays an error message when title is missing" do
        post :create, params: { review: { title: "", body: "Great video!", video_id: video.id } }
        expect(flash[:alert]).to include("Title can't be blank")
      end
    end
  end
end
