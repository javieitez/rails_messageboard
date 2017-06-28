require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
      @base_title = "Message Board"
  end

  test "Everything wrong in signup form" do
    get new_user_path
    assert_select "title", "Create your account | #{@base_title}"
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
  end

  test "invalid password confirmation in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "username",
                                        password:              "foo123456789",
                                        password_confirmation: "bar123456789" } }
    end
  end

  test "password too short in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "username",
                                        password:              "foo",
                                        password_confirmation: "foo" } }
    end
  end

  test "invalid username in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@val.id",
                                        username: "user name",
                                        password:              "foo123456789",
                                        password_confirmation: "foo123456789" } }
    end
  end

  test "invalid email in form" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "user name",
                                        email: "user@invalid",
                                        username: "user name",
                                        password:              "foo123456789",
                                        password_confirmation: "foo123456789" } }
    end
  end



end
