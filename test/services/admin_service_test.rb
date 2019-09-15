require 'test_helper'

class AdminServiceTest < ActiveSupport::TestCase
  test "assign_restaurant_to_courier-success" do
    admin = users(:yasir)
    service = AdminService.new(admin)
    abdullah = users(:abdullah)
    restaurant = restaurants(:carriage)

    assert(
      !restaurant.couriers.exists?(abdullah.id),
      "Should not be already linked to the restaurant")

    result = service.assign_restaurant_to_courier(restaurant, abdullah)

    assert(
      restaurant.couriers.exists?(abdullah.id),
      "Should be linked to the restaurant")

    assert_equal(
      I18n.t('courier.assign.success'),
      service.success_message,
      "Should set success message")
    assert(service.errors.blank?, "Should have no errors")
    assert_equal(:success, service.http_status, "Should be success")
    assert_equal([:success, I18n.t('courier.assign.success')],
      result,
      "Should return the http_status and success_message")
  end

  test "assign_restaurant_to_courier-already_linked-failure" do
    admin = users(:yasir)
    service = AdminService.new(admin)
    restaurant = restaurants(:carriage)

    assert(
      restaurant.couriers.exists?(admin.id),
      "Should be already linked to the restaurant")

    result = service.assign_restaurant_to_courier(restaurant, admin)

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

  test "unassign_restaurant_to_courier-success" do
    admin = users(:yasir)
    service = AdminService.new(admin)
    restaurant = restaurants(:carriage)

    assert(
      restaurant.couriers.exists?(admin.id),
      "Should be already linked to the restaurant")

    result = service.unassign_restaurant_to_courier(restaurant, admin)

    assert(
      !restaurant.couriers.exists?(admin.id),
      "Should be unlinked from the restaurant")

    assert_equal(
      I18n.t('courier.unassign.success'),
      service.success_message,
      "Should set success message")
    assert(service.errors.blank?, "Should have no errors")
    assert_equal(:success, service.http_status, "Should be success")
    assert_equal([:success, I18n.t('courier.unassign.success')],
      result,
      "Should return the http_status and success_message")
  end

  test "unassign_restaurant_to_courier-not_linked-failure" do
    admin = users(:yasir)
    abdullah = users(:abdullah)
    service = AdminService.new(admin)
    restaurant = restaurants(:carriage)

    assert(
      !restaurant.couriers.exists?(abdullah.id),
      "Should not be already linked to the restaurant")

    result = service.unassign_restaurant_to_courier(restaurant, abdullah)

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
