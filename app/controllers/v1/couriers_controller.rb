class V1::CouriersController < ApplicationController
  before_action :set_courier, :set_restaurant, :set_authorizer
  before_action -> { render_unauthorized unless @authorizer.can_access_restaurant? }
  before_action :set_service

  def assign
    status, message = @service.assign_restaurant(@restaurant)

    render json: { message: message }, status: status
  end

  def unassign
    status, message = @service.unassign_restaurant(@restaurant)

    render json: { message: message }, status: status
  end

  private

  def set_courier
    @courier = User.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_service
    @service = CourierCreationService.new(@courier)
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, @restaurant)
  end
end
