require 'test_helper'

class V1::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rooney = users(:rooney)
    @admin = users(:azgar)
    @unauthorized = users(:jhonny)
    @post = posts(:kfc_rooney)
    @comment = comments(:kfc_rooney_canntona)
    @comment_creator = users(:canntona)
  end

  test "index" do
    json_get(v1_post_comments_url(@post, limit: 2), @comment_creator)

    assert_response :success
    assert_equal(response_index, json_response['comments'],
      "Should return comments created for the post")

    assert_pagination_headers(3)
  end

  test "show-unauthorized" do
    json_get(v1_comment_url(@comment, format: :json), @unauthorized)

    assert_access_forbidden
  end

  test "show-unaccessible_restaurant_is_authorized_to_admin" do
    json_get(v1_comment_url(@comment, format: :json), @admin)

    assert_show_success
    assert_pagination_headers(3)
  end

  test "show-authorized_non_admin" do
    json_get(v1_comment_url(@comment, format: :json), @comment_creator)

    assert_show_success
    assert_pagination_headers(3)
  end

  test "create-unauthorized_fails" do
    json_post(v1_post_comments_url(@post, format: :json), @unauthorized, create_params)

    assert_access_forbidden
  end

  test "create-unaccessible_restaurant_is_authorized_to_admin" do
    assert_create_success(@admin)
  end

  test "create-success_authorized_user" do
    assert_create_success(@comment_creator)
  end

  test "create-fail_authorized_user_without_body" do
    params = create_params
    params[:comment][:body] = nil
    assert_difference('Comment.count', 0) do
      json_post(v1_post_comments_url(@post, format: :json), @comment_creator, params)
      assert_response :bad_request
    end
  end

  test "update-unauthorized" do
    json_patch(v1_comment_url(@comment, format: :json), @unauthorized)

    assert_access_forbidden
  end

  test "update-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_patch(v1_comment_url(@comment, format: :json), @admin)

    assert_access_forbidden
  end

  test "update-authorized_non_admin_success" do
    json_patch(v1_comment_url(@comment, format: :json), @comment_creator, update_params)
    assert_response :success

    assert_equal(
      I18n.t('comment.update.success'),
      json_response['message'], "Should set success message")
  end

  test "update-authorized_non_admin-failure" do
    params = update_params
    params[:comment][:body] = nil

    json_patch(v1_comment_url(@comment, format: :json), @comment_creator, params)
    assert_response :bad_request
  end

  test "destroy-unauthorized" do
    json_delete(v1_comment_url(@comment, format: :json), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_delete(v1_comment_url(@comment, format: :json), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-authorized_non_admin" do
    assert_difference('Comment.count', -1) do
      json_delete(v1_comment_url(@comment, format: :json), @comment_creator)
    end
  end

  private

  def response_index
    [
      comments(:kfc_rooney_abdullah),
      comments(:kfc_rooney_razvi)
    ].map do |comment|
      [comment.id, comment.user.id, comment.body]
    end
  end

  def assert_show_success
    assert_response :success

    replies = [
      replies(:kfc_rooney_canntona_abdullah1),
      replies(:kfc_rooney_canntona_abdullah2),
      replies(:kfc_rooney_canntona_yasir)
    ].map { |reply| [reply.id, reply.user_id, reply.body] }

    json = {
      'comment' => @comment.body,
      'replies' => replies
    }

    assert_equal(json, json_response,
      "Should return post details and comments")
  end

  def create_params
    {
      comment:{
        body: 'Hi'
      }
    }
  end

  def assert_create_success(user)
    assert_difference('Comment.count', 1) do
      assert_difference('@post.comments.count', 1) do
        json_post(v1_post_comments_url(@post, format: :json), user, create_params)
        assert_response :success
        assert_not_nil(json_response['id'], "Should set created comment id")
        assert_equal(
          I18n.t('comment.create.success'),
          json_response['message'], "Should set success message")
      end
    end
  end

  def update_params
    {
      comment: {
        body: "Hello"
      }
    }
  end
end
