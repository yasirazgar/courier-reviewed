require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    username = 'yasir'
    email = 'yasir22@carriage.com'
    duplicate_email = 'yasir@carriage.com'

    assert(
      User.new(username: username, email: email).valid?,
      "Should be valid, when valid username and  email is present")
    assert_not(
      User.new(username: username, email: duplicate_email).valid?,
      "Should not be valid, when email is duplicate")
    assert_not(
      User.new(username: username).valid?,
      "Should not be valid, when email is not present")
    assert_not(
      User.new(email: email).valid?,
      "Should not be valid, when username is not present")
  end

  test "has_and_belongs_to_many :restaurants" do
    user = users(:one)

    assert_equal(
      user.restaurants,
      [],
      "Should return all assinged restaurants")
  end
end
