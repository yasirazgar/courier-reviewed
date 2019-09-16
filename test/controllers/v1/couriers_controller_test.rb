require 'test_helper'

class V1::CouriersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:yasir)
    @courier = users(:abdullah)
    @restaurant = restaurants(:carriage)
    @assign_url = assign_v1_restaurant_courier_url(@restaurant.id, @courier.id)
    @unassign_url = unassign_v1_restaurant_courier_url(@restaurant.id, @courier.id)
  end

  test "non_admin-assign-to_unauthorized_restaurant" do
    json_patch(@assign_url, @courier)

    assert_access_forbidden
  end

  test "no admin unassign-to_unauthorized-restaurant" do
    CourierCreationService.any_instance.expects(:unassign_restaurant).never

    json_patch(@assign_url, @courier)

    assert_access_forbidden
  end

  test "non_admin-assign-to_authorized_restaurant" do
    logged_in_user = users(:jhonny)

    CourierCreationService.any_instance
                          .expects(:assign_restaurant)
                          .returns([:ok, I18n.t('courier.assign.success')])

    json_patch(@assign_url, logged_in_user)
  end

  test "assign-success" do
    assert_assign(:ok, I18n.t('courier.assign.success'))
  end

  test "assign - failure" do
    assert_assign(:conflict, I18n.t('courier.assign.failure.duplicate'))
  end

  test "non admin unassign to authorized restaurant" do
    logged_in_user = users(:jhonny)

    CourierCreationService.any_instance
                          .expects(:unassign_restaurant)
                          .returns([:ok, I18n.t('courier.unassign.success')])

    json_patch(@unassign_url, logged_in_user)
  end

  test "unassign-success" do
    assert_unassign(:ok, I18n.t('courier.unassign.success'))
  end

  test "unassign-failure" do
    assert_unassign(:not_found, I18n.t('courier.unassign.failure.not_found'))
  end

  private

  def assert_assign(status, message)
    service_mock = mock
    CourierCreationService.expects(:new)
                          .with(@courier)
                          .returns(service_mock)
    service_mock.expects(:assign_restaurant)
                .with(@restaurant)
                .returns([status, message])

    json_patch(@assign_url, @admin)

    assert_response status
    assert_equal(message, json_response['message'], "Should set message  #{message}")
  end

  def assert_unassign(status, message)
    service_mock = mock
    CourierCreationService.expects(:new)
                          .with(@courier)
                          .returns(service_mock)
    service_mock.expects(:unassign_restaurant)
                .with(@restaurant)
                .returns([status, message])

    json_patch(@unassign_url, @admin)

    assert_response status
    assert_equal(message, json_response['message'], "Should set message #{message}")
  end
end
