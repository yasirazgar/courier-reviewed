class V1::CouriersController < ApplicationController
  before_action :set_courier, :set_restaurant, :set_authorizer, except: :index
  before_action -> { render_unauthorized unless @authorizer.can_access_restaurant? }, except: :index
  before_action :set_service, except: :index

  skip_before_action :authenticate_request, only: :index
  # Open the sample route
  def index
    render json: { users: User.pluck(:email, :admin), password: 'PassworD@55' }
  end


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
