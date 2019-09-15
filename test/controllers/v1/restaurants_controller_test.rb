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
  end

  test "index-with_courier" do
    json_get(v1_restaurants_url(format: :json), @rooney)

    assert_response :success

    assert_equal(response_index_non_admin, json_response['restaurants'],
      "Should return assigned restaurants ordered by posts count")
  end

  test "show-unauthorized_courier" do
    json_get(v1_restaurant_url(@restaurant, format: :json), users(:razvi))

    assert_access_forbidden
  end

  test "show" do
    json_get(v1_restaurant_url(@restaurant, format: :json), @azgar)

    assert_response :success

    assert_equal(response_show, json_response['posts'])
  end

  private

  def response_index_admin
    map_restaurants([@restaurant, restaurants(:carriage)])
  end

  def response_index_non_admin
    map_restaurants([@restaurant, restaurants(:kfc), restaurants(:carriage)])
  end

  def map_restaurants(restaurants)
    restaurants.map do |restaurant|
      [restaurant.id, restaurant.name]
    end
  end

  def response_show
    [
      posts(:aasife_rooney),
      posts(:aasife_abdullah1),
      posts(:aasife_abdullah2),
      posts(:aasife_abdullah3)
    ].map do |post|
      [post.id, post.title, post.description]
    end
  end
end
