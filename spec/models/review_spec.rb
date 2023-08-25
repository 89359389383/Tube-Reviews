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
end
