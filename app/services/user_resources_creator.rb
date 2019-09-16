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
end
