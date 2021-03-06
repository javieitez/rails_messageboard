require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Message Board"
    @user = users(:user1)
    @picture = fixture_file_upload('kitten.jpg', 'image/jpg')
    @picture2 = fixture_file_upload('rails.png', 'image/png')
    @article = Article.find_by_id(2)
    @own_article = Article.find_by_id(1)
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

  test "should wrap insanely long words" do
    log_in_as @user
    get new_article_path
    post articles_path, params: {article:  { subject: "insanelylongwords", 
                                                  text: 'w' * 500 } } 
    follow_redirect!
    get articles_path
    assert_select 'a', 'insanelylongwords'
    assert_select 'div', {count: 0, text: 'w' * 500}
  end


	test "should raise error when posting incorrect note" do
    log_in_as @user
    get new_article_path
    post articles_path, params: {article:  { subject: "123", 
                                                  text: "a " * 100,
                                                  user_id: 1 } } 
    assert_select 'th', {count: 0, text: "123"}, "note must not be
                                                              rendered in table"
    assert_select 'input[value=?]', '123'
    assert_select 'div[id=?]', 'error_explanation'
	end
  


  test "post new note with image, then edit" do
    #create a new note 
      log_in_as @user
      get new_article_path
      post articles_path, params: {article:  { subject: "thisisthesubject", 
                                                    text: "a " * 100,
                                                    picture: @picture} } 
  #check the note has been saved and
  #that things are in place
      assert_response :redirect, "Not redirected"
      follow_redirect!
      assert_response :success
      assert_not flash.empty?, "no Flash on new note"
      assert_select 'th', /.*thisisthesubject/ 
      assert_select 'img[alt=?]', 'Kitten'
      assert_select 'a[href=?]', edit_article_path
  #edit the note, just replacing the picture
      get edit_article_path
      assert_select "title", "Edit Note | #{@base_title}"
      put article_path, params: {article: {picture: @picture2}}
  #check for the picture to be replaced 
  #and the subject to remain the same
      assert_response :redirect, "Not redirected"
      follow_redirect!
      assert_response :success
      assert_select 'img[alt=?]', 'Rails'
      assert_select 'th', /.*thisisthesubject/ #regexp to include text before 
  #now edit the subject and remove the picture 
      get edit_article_path
      put article_path, params: {article: {subject: "subject changed", 
                                              remove_picture: true }}
  #check for the changed subject and the removed image
      assert_response :redirect, "Not redirected"
      follow_redirect!
      assert_not flash.empty?, "no Flash on edited note"
      assert_select 'th', /.*subject changed/
      assert_select 'img[alt=?]', 'Kitten', count: 0
  end

  test "must not edit posts from other users" do
    log_in_as @user
      get edit_article_path(@article)
      put article_path(@article), params: {article: {subject: "subject hacked"}}  
      assert_not @article.subject == "subject hacked"
      assert @article.subject == "subject of the 2nd article"
      put article_path(@article), params: {article: {text: "text hacked " * 3}}  
      assert_not @article.text == "text hacked " * 3
  end

  test "must not create articles if not logged in" do
    delete user_path(@user)
    assert_no_difference 'Article.count' do
      post articles_path, params: {article: {subject: "article hacked", 
                                                        text: "a word"  * 50 }}
    end
  end

  test "must create articles if logged in" do
    log_in_as @user
    assert_difference 'Article.count', 1 do
      post articles_path, params: {article: {subject: "subject " * 3, 
                                                        text: "a word"  * 50 }}
    end
  end

  test "must not delete posts from other users" do
    log_in_as @user
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
  end
  
  test "must delete their own posts" do
    log_in_as @user
    assert_difference 'Article.count', -1 do
      delete article_path(@own_article)
    end
  end


end
