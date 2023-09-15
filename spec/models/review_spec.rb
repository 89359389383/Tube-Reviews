require 'rails_helper'

RSpec.describe Review, type: :model do
  # バリデーションのテスト
  it "is valid with content" do
    review = Review.new(content: "This is a sample review.")
    expect(review).to be_valid
  end

  it "is invalid without content" do
    review = Review.new(content: nil)
    expect(review).not_to be_valid
  end

  it "does not allow content to be over a certain length" do
    review = Review.new(content: "a" * 501) # Assuming max length is 500 characters
    expect(review).not_to be_valid
  end

  # アソシエーションのテスト
  it "belongs to a user" do
    should belong_to(:user)
  end

  it "belongs to a video" do
    should belong_to(:video)
  end

  # 並び替えとフィルタリングのテスト
  describe "filter_by_title" do
    before(:each) do
      @review1 = create(:review, title: "Title1")
      @review2 = create(:review, title: "Title2")
    end

    context "when a 'Title1' title pattern is sent" do
      it "returns the review1 with title 'Title1'" do
        expect(Review.filter_by_title("Title1")).to include(@review1)
        expect(Review.filter_by_title("Title1")).not_to include(@review2)
      end
    end
  end
end

