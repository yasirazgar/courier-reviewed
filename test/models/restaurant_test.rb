require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:yasir)
    name = 'carriage'

    assert(
      Restaurant.new(creator: user, name: name).valid?,
      "Should be valid, when creator and name is present")
    assert_not(
      Restaurant.new(creator: user).valid?,
      "Should not be valid, when name is not present")
    assert_not(
      Restaurant.new(name: name).valid?,
      "Should not be valid, when creator is not present")
  end

  test "has_and_belongs_to_many :couriers" do
    restaurant = restaurants(:carriage)

    assert_equal(
      [
        users(:yasir),
        users(:razvi),
        users(:jhonny),
        users(:canntona),
        users(:rooney)
      ], restaurant.couriers,
      "Should return all assinged couriers")
  end
end
