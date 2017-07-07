require 'test_helper'

class PageNavigationTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Message Board"
    @user = users(:user1)
  end
  
  test "should get root + title" do # root must be articles index
    get login_path
    log_in_as @user
    follow_redirect!
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  
  test "should get new" do
    log_in_as @user
    get new_article_path
    assert_response :success
    assert_select "title", "Compose new Note | #{@base_title}"
    assert_select 'input[type=file]'
  end


end
