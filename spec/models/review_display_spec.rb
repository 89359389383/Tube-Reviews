# spec/models/review_spec.rb

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review)
      expect(review).to be_valid
    end

    it 'is invalid without a body' do
      review = build(:review, body: nil)
      expect(review).not_to be_valid
      expect(review.errors[:body]).to include("can't be blank")
    end

    it 'is invalid with a too short body' do
      review = build(:review, body: 'a' * 4)
      expect(review).not_to be_valid
      expect(review.errors[:body]).to include("is too short (minimum is 5 characters)")
    end

    it 'is invalid with a too long body' do
      review = build(:review, body: 'a' * 501)
      expect(review).not_to be_valid
      expect(review.errors[:body]).to include("is too long (maximum is 500 characters)")
    end
  end

  describe 'scopes' do
    it 'orders reviews by created_at in descending order' do
      review1 = create(:review, created_at: 1.day.ago)
      review2 = create(:review, created_at: Time.now)
      expect(Review.recent).to eq([review2, review1])
    end
  end
end
