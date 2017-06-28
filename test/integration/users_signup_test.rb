require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
      @base_title = "Message Board"
  end

  test "invalid signup information" do
    get new_user_path
    assert_select "title", "Create your account | #{@base_title}"
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

  end


end
