# spec/controllers/reviews_controller_spec.rb

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create(:video) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid data" do
      it "saves the new review" do
        post :create, params: { review: { content: "Great video!", video_id: video.id } }
        expect(Review.last.content).to eq("Great video!")
      end
    end
    
    context "with invalid data" do
      it "displays an error message" do
        post :create, params: { review: { content: "", video_id: video.id } }
        expect(flash[:alert]).to eq("Content can't be blank")
      end
    end
  end
end


