require 'test_helper'

class DashBoardControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get dash_board_home_url
    assert_response :success
  end

  test "should get help" do
    get dash_board_help_url
    assert_response :success
  end

end
