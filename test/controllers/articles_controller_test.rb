require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
      @base_title = "Message Board"
  end

  test "should get root + title" do # root must be articles index
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get index + title" do
    get articles_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  
  # 3rd article in fixtures conforms to this test
  test "Large notes should be splitted at 30 words" do
    get articles_path
    assert_response :success
    assert_select 'div[class=?]', 'readmore'
  end

  test "should get new + title" do
    get new_article_path
    assert_response :success
    assert_select "title", "Compose new message | #{@base_title}"
  end

  test "should redirect and flash when posting new note" do
    get new_article_path
    post articles_path, params: {article:  { subject: "123456", 
                                                  text: "a" * 100 } } 
    assert_response :redirect, "Not redirected"
    follow_redirect!
    assert_response :success
    assert_not flash.empty?, "Flash is empty"
    assert_select 'th', '123456', "note not rendered"
  end

  test "should raise error when posting incorrect note" do
    get new_article_path
    post articles_path, params: {article:  { subject: "123", 
                                                  text: "a" * 100 } } 
    assert_select 'th', {count: 0, text: "123"}, "note must not be
                                                              rendered in table"
    assert_select 'input[value=?]', '123'
    assert_select 'div[id=?]', 'error_explanation'
  end

end