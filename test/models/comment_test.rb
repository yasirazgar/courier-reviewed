require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:yasir)
    post = posts(:carriage_yasir)
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
    comment = comments(:carriage_yasir_rooney)

    assert_not_empty(comment.replies, "Should have replies")

    comment.destroy
    assert_empty(
      Reply.where(comment_id: comment.id),
      "Should delete all replies when the respective comment is destroyed")
  end

  test "counter_cache - replies_count" do
    comment = comments(:carriage_yasir_rooney)
    user = users(:yasir)
    old_count = 1
    new_count = 2

    assert_equal(
      old_count, comment.replies.size,
      "Should have #{old_count} replies size")
    assert_equal(
      old_count, comment.replies_count,
      "Should have #{old_count} replies_count")

    reply_attrs = {
      comment: comment,
      user: user,
      body: "I agree"
    }
    comment.replies << Reply.create(reply_attrs)
    assert_equal(
      new_count, comment.replies_count,
      "Should update replies_count to #{new_count}")
  end
end
