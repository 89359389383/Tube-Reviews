# db/seeds.rb

# ユーザーサンプルデータ
user1 = User.create!(name: 'newuser1', email: 'newuser1@example.com', password: 'password123')
user2 = User.create!(name: 'newuser2', email: 'newuser2@example.com', password: 'password123')

# レビューサンプルデータ
Review.create!(body: 'Great video!', user: user1, video: video1)
Review.create!(body: 'Not bad.', user: user1, video: video2)
Review.create!(body: 'I liked this one.', user: user2, video: video1)
