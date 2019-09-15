require 'test_helper'

class V1::Admin::RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @yasir = users(:yasir)
    @restaurant = restaurants(:carriage)
  end

  test "create admin-access" do
    json_post(v1_admin_restaurants_url(format: :json), users(:jhonny))
    assert_access_forbidden
  end

  test "create-success" do
    assert_difference("Restaurant.count", 1, "Should add a restaurant") do
      assert_difference("@yasir.created_restaurants.count", 1, "Should add a restaurant to yasir") do
        json_post(v1_admin_restaurants_url(format: :json), @yasir, create_params)
        assert_response :success
        assert json_response['id'], "Should set id"
        assert_equal(
          I18n.t('restaurant.create.success'),
          json_response['message'],
          "Should set success message")
      end
    end
  end

  test "create-error" do
    params = create_params
    params[:restaurant][:name] = nil

    assert_difference("Restaurant.count", 0, "Should add a restaurant") do
      assert_difference("@yasir.created_restaurants.count", 0, "Should add a restaurant to yasir") do
        json_post(v1_admin_restaurants_url(format: :json), @yasir, params)
        assert_response :bad_request
      end
    end
  end

  test "update admin-access" do
    json_patch(v1_admin_restaurant_url(@restaurant, format: :json), users(:jhonny))
    assert_access_forbidden
  end

  test "update-success" do
    params = update_params
    json_patch(v1_admin_restaurant_url(@restaurant, format: :json), @yasir, params)

    assert_equal(
      params[:restaurant][:name],
      @restaurant.reload.name,
      "Should update the name of the restaurant"
      )
  end

  test "update-failure" do
    params = update_params
    params[:name] = nil
    json_patch(v1_admin_restaurant_url(@restaurant, format: :json), @yasir, params)

    assert(@restaurant.reload.name, "Should not update name")
  end

  def create_params
    params = {
      restaurant:{
        name: 'New Restaurant',
        user_id: @yasir.id,
      }
    }
  end

  def update_params
    params = {
      restaurant:{
        name: 'Updated Restaurant'
      }
    }
  end
end

