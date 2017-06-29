require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:user1)
  end

  
  test "invalid login should return only 1 flash" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information, then logout" do
    get login_path
    assert_select "a[href=?]", login_path, count: 0
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    #check if the profile link is hidden in the user page
      get user_path(@user)
      assert_template 'users/show'
      assert_select "a[href=?]", user_path(@user), count: 0
    #logout
      delete logout_path
      assert_not is_logged_in?
      assert_redirected_to root_url
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(@user), count: 0
  end


end