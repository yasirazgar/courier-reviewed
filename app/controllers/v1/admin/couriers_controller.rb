class V1::Admin::CouriersController < V1::AdminController
  before_action :set_courier, :set_restaurant, :set_service

  def assign
    status, message = @service.assign_restaurant_to_courier(@restaurant, @courier)

    render json: { message: message }, status: status
  end

  def unassign
    status, message = @service.unassign_restaurant_to_courier(@restaurant, @courier)

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
    @service = AdminService.new(current_user)
  end
end
