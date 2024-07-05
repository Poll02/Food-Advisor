require "test_helper"

class PreferitiControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get preferiti_show_url
    assert_response :success
  end
end
