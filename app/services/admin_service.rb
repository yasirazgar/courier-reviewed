class AdminService
  attr_accessor :errors, :http_status, :success_message

  def initialize(user)
    raise "Not admin" unless user.admin?
    @admin = user
    @errors = []
    @success_message = nil
    @http_status = nil # Always success if the request processed successfully
  end

  def assign_restaurant_to_courier(restaurant, user)
    if user.restaurants.exists?(restaurant.id)
      @errors << I18n.t('courier.assign.failure.duplicate')
      @http_status = :conlict
      return [@http_status, @errors.join(', ')]
    end

    user.restaurants << restaurant
    @success_message = I18n.t('courier.assign.success')
    @http_status = :ok

    [@http_status, @success_message]
  end

  def unassign_restaurant_to_courier(restaurant, user)
    if user.restaurants.exists?(restaurant.id)
      user.restaurants.delete(restaurant)
      @http_status = :ok
      @success_message = I18n.t('courier.unassign.success')
      return [@http_status, @success_message]
    end

    @errors << I18n.t('courier.unassign.failure.not_found')
    @http_status = :not_found

    [@http_status, @errors.join(', ')]
  end
end
