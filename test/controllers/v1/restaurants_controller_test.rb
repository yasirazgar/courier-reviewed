require 'test_helper'

class V1::RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @azgar = users(:azgar)
    @rooney = users(:rooney)
    @restaurant = restaurants(:aasife)
  end

  test "index-with_admin" do
    json_get(v1_restaurants_url(format: :json), @azgar)

    assert_response :success
    assert_equal(response_index_admin, json_response['restaurants'],
      "Should return both assigned and created restaurants ordered by posts counts")

    assert_pagination_headers(2)
  end

  test "index-with_courier" do
    json_get(v1_restaurants_url(format: :json, limit: 2), @rooney)

    assert_response :success

    assert_equal(response_index_non_admin, json_response['restaurants'],
      "Should return assigned restaurants ordered by posts count")

    assert_pagination_headers(3)
  end

  test "show-unauthorized_courier" do
    json_get(v1_restaurant_url(@restaurant), users(:razvi))

    assert_access_forbidden
  end

  test "show" do
    json_get(v1_restaurant_url(@restaurant, limit: 2), @azgar)

    assert_response :success

    assert_equal(response_show, json_response,
      "Should show posts in restaurants ordered by posts_count")

    assert_pagination_headers(4)
  end

  private

  def response_index_admin
    map_restaurants([@restaurant, restaurants(:carriage)])
  end

  def response_index_non_admin
    map_restaurants([@restaurant, restaurants(:kfc)])
  end

  def map_restaurants(restaurants)
    restaurants.map do |restaurant|
      [restaurant.id, restaurant.name]
    end
  end

  def response_show
    posts = [
      posts(:aasife_rooney),
      posts(:aasife_abdullah1)
    ].map do |post|
      [post.id, post.title, post.description]
    end

    {
      'restaurant' => @restaurant.name,
      'posts' => posts
    }
  end
end
