# spec/models/favorite_spec.rb
require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:favorite) } # ここではFactoryBotを使用しており、事前にFactoryの設定が必要です。

    it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }

    it 'validates uniqueness of video in the scope of user' do
      user = FactoryBot.create(:user)
      video = FactoryBot.create(:video)
      FactoryBot.create(:favorite, user: user, video: video)

      duplicate_favorite = Favorite.new(user: user, video: video)

      expect(duplicate_favorite).not_to be_valid
      expect(duplicate_favorite.errors.full_messages).to include('User has already been taken')
    end
  end
end
