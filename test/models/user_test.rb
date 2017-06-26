require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                                          username: "exampleuser",
            about: "Lorem ipsum cogito ergo sum timeo danaos et dona ferentes")
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



end