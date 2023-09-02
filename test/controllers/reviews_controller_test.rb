require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @video = videos(:one)
    @review = reviews(:one)
    sign_in @user
  end

  test "should get edit" do
    get edit_video_review_path(@video, @review)
    assert_response :success
  end
end


