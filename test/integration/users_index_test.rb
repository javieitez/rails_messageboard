require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:user1)
    @non_admin = users(:user2)
  end
  
  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
      User.paginate(page: 1).each do |user|
        assert_select 'a[href=?]', user_path(@admin)#, text: @user.name - 
      end
    assert_select 'a[href=?][data-method=delete]', user_path(@non_admin)
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    #make sure the link to the other user exists, but not the delete option
    assert_select "a[href=?]", user_path(@admin), count: 1
    assert_select "a[href=?][data-method=delete]", user_path(@admin), count: 0
    #make sure regular users cannot delete
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
  end


end
