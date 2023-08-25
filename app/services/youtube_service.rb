# app/services/youtube_service.rb

require 'httparty'

class YoutubeService
  BASE_URL = 'https://www.googleapis.com/youtube/v3'

  # 検索クエリを使用してYouTube APIから動画情報を取得する
  def self.search_videos(query)
    response = HTTParty.get("#{BASE_URL}/search", query: {
      part: 'snippet',
      q: query,
      type: 'video',
      key: ENV['YOUTUBE_API_KEY']
    })

    if response.success?
      # 応答から必要な部分を抽出し、アプリケーションで利用しやすい形式に変換
      response.parsed_response["items"].map do |item|
        {
          title: item["snippet"]["title"],
          video_id: item["id"]["videoId"],
          thumbnail_url: item["snippet"]["thumbnails"]["default"]["url"]
        }
      end
    else
      # エラーレスポンスの場合、空の配列またはエラーメッセージを返すなどの処理を追加
      []
    end
  end

  # 指定した動画IDを使用してYouTube APIから動画の詳細情報を取得する
  def self.fetch_video_details(video_id)
    response = HTTParty.get("#{BASE_URL}/videos", query: {
      part: 'snippet',
      id: video_id,
      key: ENV['YOUTUBE_API_KEY']
    })

    if response.success?
      # 応答から動画の詳細情報を抽出するロジックをここに書く
      # この例では、最初の動画の詳細情報を直接返していますが、実際の要件に合わせて調整してください
      response.parsed_response["items"].first
    else
      # エラーレスポンスの場合、nilやエラーメッセージを返すなどの処理を追加
      nil
    end
  end
end