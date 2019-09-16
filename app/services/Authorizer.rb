class Authorizer

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def can_access_restaurant?
    @user.admin? || @user.restaurants.exists?(@resource.id)
  end

  def can_access_post?
    @user.admin? || @user.restaurants.exists?(@resource.restaurant_id)
  end

  def can_edit_post?
    @user.restaurants.exists?(@resource.restaurant_id)
  end

  def can_access_comment?
    @user.admin? || @user.restaurants.exists?(@resource.restaurant.id)
  end

  def can_edit_comment?
    (@resource.user_id == @user.id) ||
    (@user.admin? && @user.created_restaurants.exists?(@resource.restaurant.id))
  end

end
