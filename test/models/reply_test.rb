require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:one)
    comment = comments(:one)
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

  test "counter_cache - replies_count" do
    comment = comments(:one)
    user = users(:one)
    old_count = 3
    new_count = 4

    assert_equal(
      comment.comments.size, old_count,
      "Should have #{old_count} comments size")
    assert_equal(
      comment.comments_count, old_count,
      "Should have #{old_count} comments_count")

    comment_attrs = {
      comment: comment,
      user: user,
      body: "I agree"
    }
    comment.comments << Comment.create(comment_attrs)
    assert_equal(
      comment.comments_count, new_count,
      "Should update comments_count to #{new_count}")
  end
end
