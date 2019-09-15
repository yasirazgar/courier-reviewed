class Authorizer

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def can_access_restaurant?
    (@user.admin? || @user.restaurants.exists?(@resource.id))
  end

  private

  def render_unauthorized_json
    render(:json => {
        :error => {:message => I18n.t('authorization.not_allowed')}
      },
      :status => 403)
  end
end
