class Authorizer

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def can_access_restaurant?
    @user.admin? || @user.restaurants.exists?(@resource.id)
  end

  def can_access_post?
    @user.admin? || @user.restaurants.exists?(@resource.restaurant.id)
  end

end
