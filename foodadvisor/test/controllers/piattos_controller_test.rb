require "test_helper"

class PiattosControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get piattos_show_url
    assert_response :success
  end

  test "should get edit" do
    get piattos_edit_url
    assert_response :success
  end

  test "should get update" do
    get piattos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get piattos_destroy_url
    assert_response :success
  end
end
