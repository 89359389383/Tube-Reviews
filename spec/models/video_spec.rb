require 'rails_helper'

RSpec.describe Video, type: :model do
  # FactoryBotを利用してテストデータの作成
  let!(:video1) { create(:video, title: "サンプル動画1", url: "http://example.com/sample1") }
  let!(:video2) { create(:video, title: "キーワードを含むサンプル動画", url: "http://example.com/sample2") }
  let!(:video3) { create(:video, title: "サンプル動画3", url: "http://example.com/sample3") }

  # バリデーションのテスト
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
    
    # URLの形式に関するテスト
    it "is invalid with an incorrect URL format" do
      video = build(:video, url: "invalid_url", title: "Sample Video")
      expect(video).not_to be_valid
    end
    
    # タイトルの長さのテスト
    it "is invalid with a title that is too long" do
      long_title = "a" * 256 # 例えば255文字を上限とする場合
      video = build(:video, url: "https://example.com/video", title: long_title)
      expect(video).not_to be_valid
    end
  end

  # アソシエーションのテスト
  describe "Associations" do
    it "can have many reviews" do
      expect(subject).to have_many(:reviews)
    end
    # 他のアソシエーションのテストも必要であればここに追加
  end

  # 検索メソッドのテスト
  describe ".search" do
    context "when the video with the keyword exists" do
      it "returns only videos matching the keyword" do
        result = Video.search("キーワード")
        expect(result).to include(video2)
        expect(result).not_to include(video1, video3)
      end
    end
    
    context "when searching with a keyword regardless of case" do
      it "returns videos matching the keyword" do
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
  end
end