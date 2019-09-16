class UserResourcesCreator

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def create_post(params)
    Post.new(params).tap do |post|
      post.user = @user
      post.restaurant = @resource
      post.save
    end
  end

  def create_comment(params)
    Comment.new(params).tap do |comment|
      comment.user = @user
      comment.post = @resource
      comment.save
    end
  end

  def create_reply(params)
    Reply.new(params).tap do |reply|
      reply.user = @user
      reply.comment = @resource
      reply.save
    end
  end

  def create_restaurant(params)
    Restaurant.new(params).tap do |restaurant|
      restaurant.user_id = @user.id
      restaurant.save
    end
  end
end
