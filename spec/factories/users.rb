FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    # 必要に応じて他の属性も追加できます
  end
end

