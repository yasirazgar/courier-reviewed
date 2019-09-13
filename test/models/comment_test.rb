require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:one)
    post = posts(:one)
    body = 'I Agree'

    required_attrs = {
      user: user,
      post: post,
      body: body
    }

    assert(
      Comment.new(required_attrs).valid?,
      "Should be valid, when all required attrs are present and valid")

    required_attrs.keys.each do |attr|
      assert_not(
        Comment.new(required_attrs.except(attr)).valid?,
        "Should not be valid, when #{attr} is not present")
    end
  end

  test "dependent destroy - replies" do
    comment = comments(:one)

    assert_not_empty comment.replies, "Should have replies"

    comment.destroy
    assert_empty(
      Reply.where(comment_id: comment.id),
      "Should delete all replies when the respective comment is destroyed")
  end

  test "counter_cache - replies_count" do
    comment = comments(:one)
    user = users(:one)
    old_count = 3
    new_count = 4

    assert_equal(
      comment.replies.size, old_count,
      "Should have #{old_count} replies size")
    assert_equal(
      comment.replies_count, old_count,
      "Should have #{old_count} replies_count")

    reply_attrs = {
      comment: comment,
      user: user,
      body: "I agree"
    }
    comment.replies << Comment.create(reply_attrs)
    assert_equal(
      comment.replies_count, new_count,
      "Should update replies_count to #{new_count}")
  end
end
