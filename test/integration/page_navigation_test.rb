require 'test_helper'

class PageNavigationTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Message Board"
    @user = users(:user1)
    @article = Article.find_by_id(2)
    @own_article = Article.find_by_id(1)
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

  test "navigation links change on context" do
    get root_path
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', signup_path
      assert_select 'a[href=?]', users_path, count: 0
      assert_select 'a[href=?]', user_path(@user), count: 0
      assert_select 'a[href=?]', edit_user_path(@user), count: 0
    log_in_as @user
    get root_path
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', signup_path, count: 0
      assert_select 'a[href=?]', users_path
      assert_select 'a[href=?]', user_path(@user)
      assert_select 'a[href=?]', edit_user_path(@user) 
    get users_path
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', signup_path, count: 0
      assert_select 'a[href=?]', users_path, count: 0
      assert_select 'a[href=?]', user_path(@user)
      assert_select 'a[href=?]', edit_user_path(@user) 
    get user_path(@user)
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', signup_path, count: 0
      assert_select 'a[href=?]', users_path
      assert_select 'a[href=?]', user_path(@user), count: 0
      assert_select 'a[href=?]', edit_user_path(@user) 
    get edit_user_path(@user)
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', signup_path, count: 0
      assert_select 'a[href=?]', users_path
      assert_select 'a[href=?]', user_path(@user)
      assert_select 'a[href=?]', edit_user_path(@user), count: 0
  end

  test "edit and delete msg links hidden when not logged in" do
    get root_path
    assert_select 'a[href=?]', edit_article_path(@article), count: 0
    assert_select 'a[href=?][data-method=?]', article_path(@article), 
                                                  "delete", count: 0
  end

  test "edit and delete msg links active only for own posts" do
    log_in_as @user
    get root_path
    assert_select 'a[href=?]', edit_article_path(@article), count: 0
    assert_select 'a[href=?][data-method=?]', article_path(@article), 
                                                  "delete", count: 0
    assert_select 'a[href=?]', edit_article_path(@own_article), count: 1
    assert_select 'a[href=?][data-method=?]', article_path(@own_article), 
                                                  "delete", count: 1
  end

end
