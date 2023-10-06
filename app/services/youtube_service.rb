require 'httparty'

class YoutubeService
  BASE_URL = 'https://www.googleapis.com/youtube/v3'
  
  # カスタムエラークラスを定義
  class YoutubeAPIError < StandardError; end

  def self.search_videos(query)
    response = HTTParty.get("#{BASE_URL}/search", query: {
      part: 'snippet',
      q: query,
      type: 'video',
      key: ENV['YOUTUBE_API_KEY']
    })

    if response["error"]
      raise YoutubeAPIError.new(response["error"]["message"])
    end

    response.parsed_response["items"].map do |item|
      video_details = fetch_video_details_by_id(item["id"]["videoId"])
      {
        title: item["snippet"]["title"],
        video_id: item["id"]["videoId"],
        thumbnail_url: item["snippet"]["thumbnails"]["default"]["url"],
        description: video_details[:description],
        published_at: video_details[:published_at]
      }
    end
  end

  # 指定した動画IDを使用してYouTube APIから動画の詳細情報を取得する
  def self.fetch_video_details_by_id(video_id)
    response = HTTParty.get("#{BASE_URL}/videos", query: {
      part: 'snippet',
      id: video_id,
      key: ENV['YOUTUBE_API_KEY']
    })

    if response.success?
      items = response.parsed_response["items"]
      if items.any?
        video = items.first
        {
          title: video["snippet"]["title"],
          description: video["snippet"]["description"],
          published_at: video["snippet"]["publishedAt"],
          url: "https://www.youtube.com/watch?v=#{video["id"]}"
        }
      else
        nil
      end
    else
      nil
    end
  end
end
