require 'httparty'

class YoutubeService
  BASE_URL = 'https://www.googleapis.com/youtube/v3'

  # カスタムエラークラス
  class YoutubeAPIError < StandardError; end

  # YouTube APIから動画を検索
  def self.search_videos(query, max_results = 50, page_token = nil)
    response = HTTParty.get("#{BASE_URL}/search", query: {
      part: 'snippet',
      q: query,
      maxResults: max_results,
      pageToken: page_token,
      type: 'video',
      key: ENV['YOUTUBE_API_KEY']
    })

    if response["error"]
      raise YoutubeAPIError.new(response["error"]["message"])
    end

    items = response.parsed_response["items"].map do |item|
      video_details = fetch_video_details_by_id(item["id"]["videoId"])
      {
        title: item["snippet"]["title"],
        video_id: item["id"]["videoId"],
        thumbnail_url: item["snippet"]["thumbnails"]["default"]["url"],
        description: video_details[:description],
        published_at: video_details[:published_at],
        duration: video_details[:duration],
        view_count: video_details[:view_count],
        channel_title: video_details[:channel_title],
        # category_name: fetch_category_name(video["snippet"]["categoryId"]) 
      }
    end

    {
      items: items,
      nextPageToken: response.parsed_response["nextPageToken"],
      prevPageToken: response.parsed_response["prevPageToken"]
    }
  end

  # 動画の詳細情報を取得
  def self.fetch_video_details_by_id(video_id)
    response = HTTParty.get("#{BASE_URL}/videos", query: {
      part: 'snippet,contentDetails,statistics',
      id: video_id,
      key: ENV['YOUTUBE_API_KEY']
    })

    if response["error"]
      raise YoutubeAPIError.new(response["error"]["message"])
    end

    video = response.parsed_response["items"].first
    {
      title: video["snippet"]["title"],
      description: video["snippet"]["description"],
      published_at: video["snippet"]["publishedAt"],
      duration: parse_duration(video["contentDetails"]["duration"]),
      view_count: video["statistics"]["viewCount"].to_i,
      channel_title: video["snippet"]["channelTitle"],
      category_name: fetch_category_name(video["snippet"]["categoryId"])
    }
  end

  # ISO 8601形式の期間を解析してより読みやすい形式に変換
  def self.parse_duration(duration)
    pattern = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/
    matches = duration.match(pattern)
    hours = matches[1]
    minutes = matches[2] || "00"
    seconds = matches[3] || "00"
    "#{hours}h#{minutes}m#{seconds}s"
  end

  # カテゴリ名を取得
  def self.fetch_category_name(category_id)
    response = HTTParty.get("#{BASE_URL}/videoCategories", query: {
      part: 'snippet',
      id: category_id,
      key: ENV['YOUTUBE_API_KEY']
    })

    if response["error"]
      raise YoutubeAPIError.new(response["error"]["message"])
    end

    category = response.parsed_response["items"].first
    category ? category["snippet"]["title"] : "Unknown"
  end
end
