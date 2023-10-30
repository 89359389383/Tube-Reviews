# spec/models/video_spec.rb
require 'rails_helper'

RSpec.describe Video, type: :model do
  let!(:video1) { create(:video, title: "サンプル動画1", url: "http://example.com/sample1", category: 'Music') }
  let!(:video2) { create(:video, title: "キーワードを含むサンプル動画", url: "http://example.com/sample2", category: 'Music') }
  let!(:video3) { create(:video, title: "サンプル動画3", url: "http://example.com/sample3", category: 'Comedy') }
  let!(:video4) { create(:video, title: "関連しないカテゴリの動画", url: "http://example.com/sample4", category: 'News') }

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
      video.valid?
      expect(video.errors[:url]).to include("is not a valid URL")
    end

    it "is invalid with a title that is too long" do
      long_title = "a" * 256
      video = build(:video, url: "https://example.com/video", title: long_title)
      video.valid?
      expect(video.errors[:title]).to include("is too long (maximum is 255 characters)")
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
        expect(result).not_to include(video1, video3, video4)
      end

      it "returns videos matching the keyword regardless of case" do
        result = Video.search("キーワード".upcase)
        expect(result).to include(video2)
        expect(result).not_to include(video1, video3, video4)
      end
    end

    context "when the video with the keyword doesn't exist" do
      it "returns an empty result" do
        result = Video.search("存在しないキーワード")
        expect(result).to be_empty
      end
    end
  end

  describe ".search_from_youtube" do
  it "returns videos from YouTube that match the search query" do
    search_query = "Test"
    youtube_response = [
      { "title" => "Test Video 1", "video_id" => "12345", "thumbnail_url" => "thumbnail1", "description" => "description1", "published_at" => "2023-10-27T00:00:00Z" },
      { "title" => "Test Video 2", "video_id" => "67890", "thumbnail_url" => "thumbnail2", "description" => "description2", "published_at" => "2023-10-28T00:00:00Z" },
    ]
    formatted_youtube_response = youtube_response.map do |video|
      {
        title: video["title"],
        url: "https://www.youtube.com/watch?v=#{video["video_id"]}",
        thumbnail_url: video["thumbnail_url"],
        description: video["description"],
        published_at: video["published_at"],
      }
    end
    allow(YoutubeService).to receive(:search_videos).with(search_query).and_return(youtube_response)

    result = Video.search_from_youtube(search_query)

    expect(result).to match_array(formatted_youtube_response)
  end
end

  describe '.recommended' do
    context 'when the video has a category' do
      it 'returns videos from the same category' do
        expect(Video.recommended(video1)).to include(video2)
        expect(Video.recommended(video1)).not_to include(video3, video4)
      end
    end

    context 'when the video does not have a category' do
      let!(:video5) { create(:video, category: nil) }

      it 'returns an empty array' do
        expect(Video.recommended(video5)).to be_empty
      end
    end
  end
end
