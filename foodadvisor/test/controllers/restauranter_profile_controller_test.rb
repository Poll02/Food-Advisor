require "test_helper"

class RestauranterProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get restauranter_profile_show_url
    assert_response :success
  end

  test "should get edit" do
    get restauranter_profile_edit_url
    assert_response :success
  end

  test "should get update" do
    get restauranter_profile_update_url
    assert_response :success
  end
end
