require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
      @base_title = "Message Board"
      ActionMailer::Base.deliveries.clear
  end

  test "Everything wrong in signup form" do
    get signup_path
    assert_select "title", "Create your account | #{@base_title}"
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                        email: "user@invalid",
                                        username: "user name",
                                        password:              "foo",
                                        password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_not is_logged_in?
  end

  test "invalid password confirmation in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "username",
                                        password:              "foo123456789",
                                        password_confirmation: "bar123456789" } }
    end
    assert_template 'users/new'
    assert_not is_logged_in?
  end

  test "password too short in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "username",
                                        password:              "foo",
                                        password_confirmation: "foo" } }
    end
    assert_not is_logged_in?
  end

  test "invalid username in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "user name",
                                        password:              "foo123456789",
                                        password_confirmation: "foo123456789" } }
    end
    assert_not is_logged_in?
  end

  test "invalid email in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@invalid",
                                        username: "user name",
                                        password:              "foo123456789",
                                        password_confirmation: "foo123456789" } }
    end
    assert_not is_logged_in?  
  end

  #test "valid signup and autologin" do
  #  get signup_path
  #  assert_difference 'User.count', 1 do
  #    post users_path, params: { user: { name:  "user name",
  #                                      email: "user@val.id",
  #                                      username: "username",
  #                                      password:              "foo123456789",
  #                                      password_confirmation: "foo123456789" } }
  #  end
  #  follow_redirect!
    #assert_template 'users/show'
    #assert is_logged_in?
  #end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "user2 name",
                                        email: "user2@val.id",
                                        username: "username2",
                                        password:              "foo123456789",
                                        password_confirmation: "foo123456789" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
