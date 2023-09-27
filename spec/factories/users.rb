# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    # 追加で他の属性が必要な場合は、こちらに追加してください
  end
end
