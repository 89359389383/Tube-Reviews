# db/seeds.rb

# ユーザーサンプルデータ
user1 = User.create!(name: 'newuser1', email: 'newuser1@example.com', password: 'password123')
user2 = User.create!(name: 'newuser2', email: 'newuser2@example.com', password: 'password123')

# 動画サンプルデータ
video1 = Video.create!(title: 'Video Sample 1', url: 'https://example.com/video1', description: 'This is a sample video description.')
video2 = Video.create!(title: 'Video Sample 2', url: 'https://example.com/video2', description: 'Another sample video description.')

# レビューサンプルデータ
Review.create!(body: 'Great video!', user: user1, video: video1)
Review.create!(body: 'Not bad.', user: user1, video: video2)
Review.create!(body: 'I liked this one.', user: user2, video: video1)
