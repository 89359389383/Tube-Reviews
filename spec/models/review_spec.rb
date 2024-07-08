require 'rails_helper'

RSpec.describe Review, type: :model do
  # 必要なデータを準備
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  let(:review) { build(:review, user: user, video: video) }

  # アソシエーションのテスト
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  # バリデーションのテスト
  describe "validations" do
    context "when all attributes are valid" do
      it "is valid" do
        expect(review).to be_valid
      end
    end

    context "when body is missing" do
      it "is not valid" do
        review.body = nil
        expect(review).not_to be_valid
      end
    end

    context "when body exceeds maximum length" do
      it "is not valid when body exceeds maximum length" do
        review.body = "a" * 501 # Assuming max length is 500 characters
        expect(review).not_to be_valid
      end
    end
  end

  # スコープのテスト
  describe "recent scope" do
    before(:each) do
      @review1 = create(:review, created_at: 1.day.ago)
      @review2 = create(:review, created_at: 2.days.ago)
      @review3 = create(:review, created_at: 3.days.ago)
    end

    it "returns reviews ordered by most recent first" do
      expect(Review.recent.first).to eq(@review1)
      expect(Review.recent.second).to eq(@review2)
      expect(Review.recent.third).to eq(@review3)
    end
  end
end
