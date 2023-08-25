# spec/controllers/reviews_controller_spec.rb

RSpec.describe ReviewsController, type: :controller do
  describe "POST #create" do
    context "with valid data" do
      it "saves the new review" do
        post :create, params: { review: { content: "Great video!", video_id: some_video_id } }  # `some_video_id`はテスト対象の動画のID
        expect(Review.last.content).to eq("Great video!")
      end
    end
    
    context "with invalid data" do
      it "displays an error message" do
        post :create, params: { review: { content: "", video_id: some_video_id } }
        expect(flash[:alert]).to eq("Review could not be saved.")
      end
    end
  end
end
