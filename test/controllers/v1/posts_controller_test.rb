require 'test_helper'

class V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rooney = users(:rooney)
    @admin = users(:azgar)
    @unauthorized = users(:jhonny)
    @restaurant = restaurants(:kfc)
    @post = posts(:kfc_rooney)
  end

  test "index" do
    json_get(v1_posts_url(limit: 2), @rooney)

    assert_response :success
    assert_equal(response_index, json_response['posts'],
      "Should posts created by the user ordered by comments count")

    assert_pagination_headers(3)
  end

  test "show-unauthorized" do
    json_get(v1_post_url(@post), @unauthorized)

    assert_access_forbidden
  end

  test "show-unaccessible_restaurant_is_authorized_to_admin" do
    json_get(v1_post_url(@post), @admin)

    assert_show_success
  end

  test "show-authorized_non_admin" do
    json_get(v1_post_url(@post), @rooney)

    assert_show_success
  end

  test "create-unauthorized_fails" do
    json_post(v1_restaurant_posts_url(@restaurant), @unauthorized, create_params)

    assert_access_forbidden
  end

  test "create-unaccessible_restaurant_is_authorized_to_admin" do
    assert_create_success(@admin)
  end

  test "create-success_authorized_user" do
    assert_create_success(@rooney)
  end

  test "create-fail_authorized_user_without_title" do
    params = create_params
    params[:post][:title] = nil

    assert_difference('Post.count', 0) do
      json_post(v1_restaurant_posts_url(@restaurant), @rooney, params)
      assert_response :bad_request
    end
  end

  test "update-unauthorized" do
    json_patch(v1_post_url(@post), @unauthorized)

    assert_access_forbidden
  end

  test "update-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_patch(v1_post_url(@post), @admin)

    assert_access_forbidden
  end

  test "update-authorized_non_admin" do
    json_patch(v1_post_url(@post), @rooney, update_params)
    assert_response :success

    assert_equal(
      I18n.t('post.update.success'),
      json_response['message'], "Should set success message")
  end

  test "update-authorized_non_admin-failure" do
    params = update_params
    params[:post][:title] = nil

    json_patch(v1_post_url(@post), @rooney, params)

    assert_response :bad_request
  end

  test "destroy-unauthorized" do
    json_delete(v1_post_url(@post), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-unaccessible_restaurant_is_unauthorized_to_admin" do
    json_delete(v1_post_url(@post), @unauthorized)

    assert_access_forbidden
  end

  test "destroy-authorized_non_admin" do
    assert_difference('Post.count', -1) do
      json_delete(v1_post_url(@post), @rooney)
    end
  end

  private

  def response_index
    [
      posts(:kfc_rooney),
      posts(:aasife_rooney)
    ].map do |post|
      [post.id, post.restaurant.name, post.title, post.description]
    end
  end

  def assert_show_success
    assert_response :success

    comments = [
      comments(:kfc_rooney_abdullah),
      comments(:kfc_rooney_razvi),
      comments(:kfc_rooney_canntona)
    ].map { |comment| [comment.id, comment.user_id, comment.body] }

    json = {
      'post' => [@post.title, @post.description],
      'comments' => comments
    }

    assert_equal(json, json_response,
      "Should return post details and comments")
  end

  def create_params
    {
      post:{
        title: 'Post title',
        description: 'Post description'
      }
    }
  end

  def assert_create_success(user)
    assert_difference('Post.count', 1) do
      assert_difference('@restaurant.posts.count', 1) do
        json_post(v1_restaurant_posts_url(@restaurant), user, create_params)
        assert_response :success
        assert_not_nil(json_response['id'], "Should set created post id")
        assert_equal(
          I18n.t('post.create.success'),
          json_response['message'], "Should set success message")
      end
    end
  end

  def update_params
    {
      post: {
        title: "New title",
        description: "New description"
      }
    }
  end
end
