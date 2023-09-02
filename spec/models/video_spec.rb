require 'rails_helper'

RSpec.describe Video, type: :model do
  let!(:video1) { create(:video, title: "サンプル動画1", url: "http://example.com/sample1") }
  let!(:video2) { create(:video, title: "キーワードを含むサンプル動画", url: "http://example.com/sample2") }
  let!(:video3) { create(:video, title: "サンプル動画3", url: "http://example.com/sample3") }

  describe "Validations" do
    it "is valid with a valid URL and title" do
      video = build(:video, url: "https://example.com/video", title: "Sample Video")
      expect(video).to be_valid
    end

    it "is invalid without a URL" do
      video = build(:video, url: nil, title: "Sample Video")
      expect(video).not_to be_valid
    end

    it "is invalid without a title" do
      video = build(:video, url: "https://example.com/video", title: nil)
      expect(video).not_to be_valid
    end

    it "is invalid with an incorrect URL format" do
      video = build(:video, url: "invalid_url", title: "Sample Video")
      expect(video).not_to be_valid
    end

    it "is invalid with a title that is too long" do
      long_title = "a" * 256
      video = build(:video, url: "https://example.com/video", title: long_title)
      expect(video).not_to be_valid
    end
  end

  describe "Associations" do
    it "can have many reviews" do
      expect(subject).to have_many(:reviews)
    end
  end

  describe ".search" do
    context "when the video with the keyword exists" do
      it "returns only videos matching the keyword" do
        result = Video.search("キーワード")
        expect(result).to include(video2)
        expect(result).not_to include(video1, video3)
      end

      it "returns videos matching the keyword regardless of case" do
        result = Video.search("キーワード".upcase)
        expect(result).to include(video2)
        expect(result).not_to include(video1, video3)
      end
    end

    context "when the video with the keyword doesn't exist" do
      it "returns an empty result" do
        result = Video.search("存在しないキーワード")
        expect(result).to be_empty
      end
    end

    it "returns videos that match the search query" do
      video1 = FactoryBot.create(:video, title: "Test Video 1")
      video2 = FactoryBot.create(:video, title: "Test Video 2")
      FactoryBot.create(:video, title: "Other Video")

      result = Video.search("Test")

      expect(result).to match_array([video1, video2])
    end
  end

  describe ".search_from_youtube" do
    it "returns videos from YouTube that match the search query" do
      search_query = "Test"
      youtube_response = [
        { "title" => "Test Video 1", "video_id" => "12345" },
        { "title" => "Test Video 2", "video_id" => "67890" },
      ]
      allow(YouTubeApi).to receive(:search_videos).with(search_query).and_return(youtube_response)

      result = Video.search_from_youtube(search_query)

      expect(result).to match_array(youtube_response)
    end
  end
end

