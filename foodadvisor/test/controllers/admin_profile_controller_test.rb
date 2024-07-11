require "test_helper"

class AdminProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_profile_show_url
    assert_response :success
  end
end
