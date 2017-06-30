require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
  end

  test "unsuccessful account edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              username: "user name",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end
  
  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  test "edit about user" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    about = "I can speak latin"
    patch user_path(@user), params: { user: { name:  "Lorem ipsum",
                                              about: about,
                                              password:              "",
                                              password_confirmation: "" } }
    @user.reload
    assert_equal about,  @user.about
  end
  
end