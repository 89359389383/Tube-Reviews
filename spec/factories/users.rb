FactoryBot.define do
  factory :user do
    username { "sample_user" }
    email { "sample@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    # 必要に応じて他の属性も追加できます
  end
end

