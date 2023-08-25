FactoryBot.define do
  factory :review do
    content { "This video was amazing!" }
    association :user
    association :video
  end
end