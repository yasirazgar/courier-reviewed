require 'test_helper'

class V1::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "create_success" do
    yasir = users(:yasir)
    params = {
      user:{
        username: 'Yash',
        email: 'yash@carriage.com',
        password: 'passworD@1'
      }
    }
    assert_difference('User.count', 1) do
      json_post(v1_admin_users_url, yasir, params)
      assert_response :success
    end
    assert_equal(
      I18n.t('user.create.success'), json_response['message'],
      "Should return success message")
  end

  test "create_failure" do
    yasir = users(:yasir)
    params = {
      user: {
        username: 'Yasir',
        email: 'yasir@carriage.com',
        password: 'passworD@1'
      }
    }
    assert_difference('User.count', 0) do
      json_post(v1_admin_users_url, yasir, params)
      assert_response :unprocessable_entity
    end
    assert_equal(
      I18n.t('user.create.failure'), json_response['message'],
      "Should return failure message")
  end
end
