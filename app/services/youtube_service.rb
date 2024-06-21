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
        thumbnail_url: item["snippet"]["thumbnails"]["high"]["url"],
        description: video_details[:description],
        published_at: video_details[:published_at],
        duration: video_details[:duration],
        view_count: video_details[:view_count],
        channel_title: video_details[:channel_title],
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
      duration: video["contentDetails"]["duration"],
      view_count: video["statistics"]["viewCount"].to_i,
      channel_title: video["snippet"]["channelTitle"],
      category_name: fetch_category_name(video["snippet"]["categoryId"])
    }
  end

  # ISO 8601形式の期間を秒数に変換
  def self.duration_to_seconds(duration)
    return 0 if duration.nil?
    
    pattern = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/
    matches = duration.match(pattern)
    return 0 if matches.nil?
    
    hours = matches[1].to_i * 3600
    minutes = matches[2].to_i * 60
    seconds = matches[3].to_i
    
    hours + minutes + seconds
  end

  # HH:MM:SS形式の文字列を返す
  def self.parse_duration(duration)
    seconds = duration_to_seconds(duration)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    seconds = seconds % 60
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  # 動画を時間でフィルタリング
  def self.filter_videos_by_duration(videos, duration_filter)
    case duration_filter
    when 'short'
      videos.select { |video| duration_to_seconds(video[:duration]) < 240 }
    when 'medium'
      videos.select { |video| duration_to_seconds(video[:duration]) >= 240 && duration_to_seconds(video[:duration]) <= 1200 }
    when 'long'
      videos.select { |video| duration_to_seconds(video[:duration]) > 1200 }
    else
      videos
    end
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
