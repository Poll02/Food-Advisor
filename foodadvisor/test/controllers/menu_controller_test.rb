require "test_helper"

class MenuControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get menu_show_url
    assert_response :success
  end
end
