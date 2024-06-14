# ユーザーサンプルデータ
user1 = User.find_or_create_by!(email: 'newuser1@example.com') do |user|
  user.name = 'newuser1'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

user2 = User.find_or_create_by!(email: 'newuser2@example.com') do |user|
  user.name = 'newuser2'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

guest_user = User.find_or_create_by!(email: 'guest@example.com') do |user|
  user.password = 'guestpassword'
  user.password_confirmation = 'guestpassword'
end

# 既存のゲストユーザーの感想データを削除
guest_user.reviews.destroy_all

# ビデオサンプルデータ
video1 = Video.find_or_create_by!(title: 'Sample Video 1') do |video|
  video.description = 'This is a sample video.'
  video.url = 'http://example.com/sample_video_1'
end

video2 = Video.find_or_create_by!(title: 'Sample Video 2') do |video|
  video.description = 'This is another sample video.'
  video.url = 'http://example.com/sample_video_2'
end
