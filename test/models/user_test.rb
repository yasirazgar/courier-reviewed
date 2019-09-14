require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    duplicate_email = 'yasir@carriage.com'
    required_attrs = {
      username: 'yasir',
      email: 'yasir22@carriage.com',
      password: 'passWord@123'
    }

    assert(
      User.new(required_attrs).valid?,
      "Should be valid, when all required attributes are present")

    required_attrs.keys.each do |attr|
      assert_not(
        User.new(required_attrs.except(attr)).valid?,
        "Should not be valid, when #{attr} is not present")
    end

    assert_not(
      User.new(required_attrs.merge(email: duplicate_email)).valid?,
      "Should not be valid, when email is duplicate")
  end

  test "has_and_belongs_to_many :restaurants" do
    user = users(:abdullah)

    assert_equal(
      user.restaurants,
      [restaurants(:aasife), restaurants(:kfc)],
      "Should return all assinged restaurants")
  end
end
