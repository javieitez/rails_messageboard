require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Message Board"
  end

  
  test "should get index" do
    get articles_path
    assert_response :success
    assert_select "title", "All messages | #{@base_title}"
  end
  
  test "should get new" do
    get new_article_path
    assert_response :success
    assert_select "title", "Compose new message | #{@base_title}"
  end

end
