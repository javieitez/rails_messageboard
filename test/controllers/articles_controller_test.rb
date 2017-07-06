require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Message Board"
  end

  #test "should get index + title" do
  #  get articles_path
  #  assert_response :success
  #  assert_select "title", "#{@base_title}"
  #end
  
  # 3rd article in fixtures conforms to this test
  #test "Large notes should be splitted at 30 words" do
  #  log_in_as(@other_user)
  #  get articles_path
  #  #assert_response :success
  #  #assert_select 'div[class=?]', 'readmore'
  #end

  test "should get new" do
    log_in_as @user
    get new_article_path
    assert_response :success
    assert_select "title", "Compose new Note | #{@base_title}"
    assert_select 'input[type=file]'
  end

  




end