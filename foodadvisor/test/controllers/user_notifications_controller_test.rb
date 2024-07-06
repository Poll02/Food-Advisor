require "test_helper"

class UserNotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_notifications_index_url
    assert_response :success
  end
end
