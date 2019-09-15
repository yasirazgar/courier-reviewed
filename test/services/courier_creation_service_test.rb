require 'test_helper'

class CourierCreationServiceTest < ActiveSupport::TestCase
  test "assign_restaurant-success" do
    abdullah = users(:abdullah)
    service = CourierCreationService.new(abdullah)
    restaurant = restaurants(:carriage)

    assert(
      !restaurant.couriers.exists?(abdullah.id),
      "Should not be already linked to the restaurant")

    result = service.assign_restaurant(restaurant)

    assert(
      restaurant.couriers.exists?(abdullah.id),
      "Should be linked to the restaurant")

    assert_equal(
      I18n.t('courier.assign.success'),
      service.success_message,
      "Should set success message")
    assert(service.errors.blank?, "Should have no errors")
    assert_equal(:ok, service.http_status, "Should be success")
    assert_equal([:ok, I18n.t('courier.assign.success')],
      result,
      "Should return the http_status and success_message")
  end

  test "assign_restaurant-already_linked-failure" do
    yasir = users(:yasir)
    service = CourierCreationService.new(yasir)
    restaurant = restaurants(:carriage)

    assert(
      restaurant.couriers.exists?(yasir.id),
      "Should be already linked to the restaurant")

    result = service.assign_restaurant(restaurant)

    assert_equal(
      [I18n.t('courier.assign.failure.duplicate')],
      service.errors,
      "Should set error saying that courier is duplicate")
    assert_equal(:conlict, service.http_status, "Should be conlict")
    assert_nil(service.success_message, "Should be nil")
    assert_equal([:conlict, I18n.t('courier.assign.failure.duplicate')],
      result,
      "Should return the http_status and error_messages")
  end

  test "unassign_restaurant-success" do
    yasir = users(:yasir)
    service = CourierCreationService.new(yasir)
    restaurant = restaurants(:carriage)

    assert(
      restaurant.couriers.exists?(yasir.id),
      "Should be already linked to the restaurant")

    result = service.unassign_restaurant(restaurant)

    assert(
      !restaurant.couriers.exists?(yasir.id),
      "Should be unlinked from the restaurant")

    assert_equal(
      I18n.t('courier.unassign.success'),
      service.success_message,
      "Should set success message")
    assert(service.errors.blank?, "Should have no errors")
    assert_equal(:ok, service.http_status, "Should be success")
    assert_equal([:ok, I18n.t('courier.unassign.success')],
      result,
      "Should return the http_status and success_message")
  end

  test "unassign_restaurant-not_linked-failure" do
    abdullah = users(:abdullah)
    service = CourierCreationService.new(abdullah)
    restaurant = restaurants(:carriage)

    assert(
      !restaurant.couriers.exists?(abdullah.id),
      "Should not be already linked to the restaurant")

    result = service.unassign_restaurant(restaurant)

    assert_equal(
      [I18n.t('courier.unassign.failure.not_found')],
      service.errors,
      "Should set error saying that courier is not found")
    assert_equal(:not_found, service.http_status, "Should be not_found")
    assert_nil(service.success_message, "Should be nil")
    assert_equal([:not_found, I18n.t('courier.unassign.failure.not_found')],
      result,
      "Should return the http_status and error_messages")
  end

end
