FactoryBot.define do
  factory :video do
    sequence(:url) { |n| "https://sample_video_url.com/#{n}" }
    title { "Sample Video" }
    description { "This is a sample video." }
    sequence(:video_id) { |n| "sample_video_id_#{n}" }
    # 必要に応じて他の属性も追加できます
  end
end