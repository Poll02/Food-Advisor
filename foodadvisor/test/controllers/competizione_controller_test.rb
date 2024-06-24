require "test_helper"

class CompetizioneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get competizione_index_url
    assert_response :success
  end
end
