require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:video) { FactoryBot.create(:video) } # このvideoファクトリが必要です

  # ユーザーが有効であることを確認
  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  # nameのバリデーションテスト
  describe "name validations" do
    it "is invalid without a name" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate name" do
      FactoryBot.create(:user, name: "duplicate_name")
      user.name = "duplicate_name"
      expect(user).to_not be_valid
    end

    it "is invalid with a name less than 3 characters" do
      user.name = "ab"
      expect(user).to_not be_valid
    end

    it "is invalid with a name more than 15 characters" do
      user.name = "a" * 16
      expect(user).to_not be_valid
    end
  end

  # emailのバリデーションテスト
  describe "email validations" do
    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate email" do
      FactoryBot.create(:user, email: "duplicate@example.com")
      user.email = "duplicate@example.com"
      expect(user).to_not be_valid
    end

    it "is invalid with an invalid email format" do
      user.email = "invalid_format"
      expect(user).to_not be_valid
    end
  end

  # passwordのバリデーションテスト
  describe "password validations" do
    it "is invalid with a password less than 6 characters" do
      user.password = "abcd5"
      user.password_confirmation = "abcd5"
      expect(user).to_not be_valid
    end
  end
end
