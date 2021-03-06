require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:yasir)
    restaurant = restaurants(:carriage)
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
    post = posts(:carriage_yasir)

    assert_not_empty(post.comments, "Should have comments")

    post.destroy
    assert_empty(
      Comment.where(post_id: post.id),
      "Should delete all comments when the respective post is destroyed")
  end

  test "counter_cache - comments_count" do
    post = posts(:carriage_yasir)
    user = users(:yasir)
    old_count = 2
    new_count = 3

    assert_equal(
      old_count, post.comments.size,
      "Should have #{old_count} comments size")
    assert_equal(
      old_count, post.comments_count,
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
    restaurant = restaurants(:kfc)
    posts_ordered_by_comments_count = [
      posts(:kfc_rooney),
      posts(:kfc_canntona),
      posts(:no_comments_kfc_rooney),
    ]

    assert_equal(
      posts_ordered_by_comments_count,
      restaurant.posts,
      "Should order by comments_count desc")
  end
end
