require 'rails_helper'

RSpec.describe Video, type: :model do
  describe ".recommended" do
    let!(:category) { "music" }
    let!(:video1) { create(:video, category: category) }
    let!(:video2) { create(:video, category: category) }
    let!(:video3) { create(:video, category: "comedy") }
    
    it "同じカテゴリの動画を返す" do
      recommended_videos = Video.recommended(video1)
      expect(recommended_videos).to include(video2)
      expect(recommended_videos).not_to include(video1)
      expect(recommended_videos).not_to include(video3)
    end

    it "5つ以下の動画を返す" do
      6.times do |i|
        create(:video, category: category)
      end
      recommended_videos = Video.recommended(video1, 1, 5)
      expect(recommended_videos.size).to be <= 5
    end
  end
end
