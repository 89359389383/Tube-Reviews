# spec/factories/reviews.rb

FactoryBot.define do
  factory :review do
    title { "Sample Review Title" }
    body { "This video was amazing!" }
    association :user
    association :video
  end
end
