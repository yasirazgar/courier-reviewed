require 'test_helper'

class V1::Admin::CouriersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:yasir)
    @courier = users(:abdullah)
    @restaurant = restaurants(:carriage)
    @assign_url = assign_v1_admin_restaurant_courier_url(@restaurant.id, @courier.id, format: :json)
    @unassign_url = unassign_v1_admin_restaurant_courier_url(@restaurant.id, @courier.id, format: :json)
  end

  test "assign-admin-access" do
    AdminService.any_instance.expects(:assign_restaurant_to_courier).never

    json_patch(@assign_url, @courier)

    assert_admin_access
  end

  test "assign-success" do
    status = :ok
    message = I18n.t('courier.assign.success')

    assert_assign(status, message)
  end

  test "assign - failure" do
    status = :conflict
    message = I18n.t('courier.assign.failure.duplicate')

    assert_assign(status, message)
  end

  test "unassign-admin-access" do
    AdminService.any_instance.expects(:unassign_restaurant_to_courier).never

    json_patch(@assign_url, @courier)

    assert_admin_access
  end

  test "unassign-success" do
    status = :ok
    message = I18n.t('courier.unassign.success')

    assert_unassign(status, message)
  end

  test "unassign-failure" do
    status = :not_found
    message = I18n.t('courier.unassign.failure.not_found')

    assert_unassign(status, message)
  end

  private

  def assert_admin_access
    assert_response :forbidden
    assert_equal(
      I18n.t('authorization.not_allowed'),
      json_response['error']['message'],
      "Should set authorization failure message")
  end

  def assert_assign(status, message)
    AdminService.any_instance
                .expects(:assign_restaurant_to_courier)
                .with(@restaurant, @courier)
                .returns([status, message])

    json_patch(@assign_url, @admin)
    assert_response status
    assert_equal(message, json_response['message'], "Should set message  #{message}")
  end

  def assert_unassign(status, message)
    AdminService.any_instance
                .expects(:unassign_restaurant_to_courier)
                .with(@restaurant, @courier)
                .returns([status, message])

    json_patch(@unassign_url, @admin)
    assert_response status
    assert_equal(message, json_response['message'], "Should set message #{message}")
  end
end
