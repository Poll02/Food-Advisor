require "test_helper"

class AdminProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_profile_edit_url
    assert_response :success
  end

  test "should get show" do
    get admin_profile_show_url
    assert_response :success
  end
end
