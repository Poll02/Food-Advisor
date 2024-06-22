require "test_helper"

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get info_show_url
    assert_response :success
  end
end
