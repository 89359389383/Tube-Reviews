require 'google/apis/youtube_v3'

YOUTUBE_SERVICE = Google::Apis::YoutubeV3::YouTubeService.new
YOUTUBE_SERVICE.key = ENV['YOUTUBE_API_KEY']
