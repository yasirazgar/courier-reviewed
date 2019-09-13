require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:one)
    restaurant = restaurants(:one)
    title = 'Carriage is awesome'
    desc = 'Carriage is awesome'
    required_attrs = {
      user: user,
      restaurant: restaurant,
      title: title
    }

    assert(
      Post.new(required_attrs).valid?,
      "Should be valid, when all required attrs are present and valid")
    assert(
      Post.new(required_attrs).valid?,
      "Should be valid, with desc and all required attrs are present")

    required_attrs.keys.each do |attr|
      assert_not(
        Post.new(required_attrs.except(attr)).valid?,
        "Should not be valid, when #{attr} is not present")
    end
  end

  test "dependent destroy - comments" do
    post = posts(:one)

    assert_not_empty post.comments, "Should have comments"

    post.destroy
    assert_empty(
      Comment.where(post_id: post.id),
      "Should delete all comments when the respective post is destroyed")
  end

  test "counter_cache - comments_count" do
    post = posts(:one)
    user = users(:one)
    old_count = 3
    new_count = 4

    assert_equal(
      post.comments.size, old_count,
      "Should have #{old_count} comments size")
    assert_equal(
      post.comments_count, old_count,
      "Should have #{old_count} comments_count")

    comment_attrs = {
      post: post,
      user: user,
      body: "I agree"
    }
    post.comments << Comment.create(comment_attrs)
    assert_equal(
      post.comments_count, new_count,
      "Should update comments_count to #{new_count}")
  end

  test "default order is comments_count desc" do
    restaurant = restaurants(:one)
    posts_by_comments_count = [
    ]

    assert_equal(restaurant.posts, posts_by_comments_count, "Should order by comments_count desc")
  end
end
