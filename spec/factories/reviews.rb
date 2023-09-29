FactoryBot.define do
  factory :review do
    title { "Sample Review Title" }
    body { "This video was amazing!" }
    association :user
    association :video

    trait :title1 do
      title { "Title1" }
    end
  end
end
