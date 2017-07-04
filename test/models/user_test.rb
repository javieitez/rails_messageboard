require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                                          username: "exampleuser",
            about: "Timeo danaos et dona ferentes",
            password: "passwd1234", password_confirmation: "passwd1234")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name must be >=5" do
    @user.name = "123"
    assert_not @user.valid?
  end

  test "name must be <400" do
    @user.name = "a"*401
    assert_not @user.valid?
  end
  
  test "username should be present" do
    @user.username = "     "
    assert_not @user.valid?
  end
  
  test "username must be >=5" do
    @user.username = "123"
    assert_not @user.valid?
  end

  test "username must be <90" do
    @user.username = "a"*100
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@example.COM A_USer@foo.bar.org
                         first.last@foo.jp name-lastname@aaaaaa.de]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    wrong_addresses = %w[userexample.com USER@example..COM @foo.bar.org
                         first.last@foojp name..lastname@dom.de name.lastname@.de]
    wrong_addresses.each do |w|
      @user.email = w
      assert_not @user.valid?, "#{w.inspect} should be rejected"
    end
  end

  test "user fields should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "user fields go lowcase" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    duplicate_user.name = @user.name.upcase
    duplicate_user.username = @user.username.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # For some reason, this test crashes Ruby if you hardcode  
  # the mixed case address instead of using a variable
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 9
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 1
    assert_not @user.valid?
  end
  
  test "username must not contain spaces" do
    @user.username = "user name"
    assert_not @user.valid?
  end

  test "username must not contain weird characters" do
    @user.username = "user,name"
    assert_not @user.valid?
  end

    test "username regexp is safe from multiline attacks" do
    @user.username = "user\name"
    assert_not @user.valid?
  end

 test "username must be unique and case insensitive" do
    @user.username = "FirstUser"
    assert_not @user.valid?
  end

 test "email must be unique" do
    @user.email = "user1@hotmail.com"
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

end