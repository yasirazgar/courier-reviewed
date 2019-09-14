require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:yasir)
    comment = comments(:carriage_yasir_rooney)
    body = 'I Agree'

    required_attrs = {
      user: user,
      comment: comment,
      body: body
    }

    assert(
      Reply.new(required_attrs).valid?,
      "Should be valid, when all required attrs are present and valid")

    required_attrs.keys.each do |attr|
      assert_not(
        Reply.new(required_attrs.except(attr)).valid?,
        "Should not be valid, when #{attr} is not present")
    end
  end
end
