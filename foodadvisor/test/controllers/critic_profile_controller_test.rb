require "test_helper"

class CriticProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get critic_profile_show_url
    assert_response :success
  end

  test "should get edit" do
    get critic_profile_edit_url
    assert_response :success
  end
end
