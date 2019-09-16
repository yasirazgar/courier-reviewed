require 'test_helper'

class V1::RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:azgar)
    @unauthorized = users(:jhonny)
    @comment = comments(:kfc_rooney_canntona)
    @reply = replies(:kfc_rooney_canntona_abdullah1)
    @reply_creator = users(:abdullah)
  end

  test "create-unauthorized_fails" do
    json_post(v1_comment_replies_url(@comment), @unauthorized, create_params)

    assert_access_forbidden
  end

  test "create-unaccessible_restaurant_is_authorized_to_admin" do
    assert_create_success(@admin)
  end

  test "create-success_authorized_user" do
    assert_create_success(@reply_creator)
  end

  test "create-fail_authorized_user_without_body" do
    params = create_params
    params[:reply][:body] = nil
    assert_difference('Reply.count', 0) do
      json_post(v1_comment_replies_url(@comment), @reply_creator, params)
      assert_response :bad_request
    end
  end

  test "update-unauthorized" do
    json_patch(v1_reply_url(@reply), @unauthorized)

    assert_access_forbidden
  end

  test "update-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_patch(v1_reply_url(@reply), @admin)

    assert_access_forbidden
  end

  test "update-authorized_non_admin_success" do
    json_patch(v1_reply_url(@reply), @reply_creator, update_params)
    assert_response :success

    assert_equal(
      I18n.t('reply.update.success'),
      json_response['message'], "Should set success message")
  end

  test "update-authorized_non_admin-failure" do
    params = update_params
    params[:reply][:body] = nil

    json_patch(v1_reply_url(@reply), @reply_creator, params)
    assert_response :bad_request
  end

  test "destroy-unauthorized" do
    json_delete(v1_reply_url(@reply), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_delete(v1_reply_url(@reply), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-authorized_non_admin" do
    assert_difference('Reply.count', -1) do
      json_delete(v1_reply_url(@reply), @reply_creator)
    end
  end

  private

  def create_params
    {
      reply:{
        body: 'Hi'
      }
    }
  end

  def assert_create_success(user)
    assert_difference('Reply.count', 1) do
      assert_difference('@comment.replies.count', 1) do
        json_post(v1_comment_replies_url(@comment), user, create_params)
        assert_response :success
        assert_not_nil(json_response['id'], "Should set created reply id")
        assert_equal(
          I18n.t('reply.create.success'),
          json_response['message'], "Should set success message")
      end
    end
  end

  def update_params
    {
      reply: {
        body: "Hello"
      }
    }
  end
end
