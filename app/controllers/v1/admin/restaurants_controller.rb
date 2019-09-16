class V1::Admin::RestaurantsController < V1::AdminController
  before_action :set_restaurant, only: [:update, :destroy]

  def create
    restaurant = UserResourcesCreator.new(current_user, nil).create_restaurant(create_params)

    if restaurant.errors.present?
      errors = restaurant.errors.full_messages.join(', ')
      render json: {errors: errors}, status: :bad_request
      return
    end

    render json: {id: restaurant.id, message: I18n.t('restaurant.create.success')}
  end

  def update
    @restaurant.update(update_params)

    if @restaurant.errors.present?
      errors = restaurant.errors.full_messages.join(', ')
      render json: { errors: errors }, status: :bad_request
      return
    end

    render json: { message: I18n.t('restaurant.update.success')}

  end

  def destroy
    @restaurant.destroy

    render json: { message: I18n.t('restaurant.destroy.success')}
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def update_params
    params.require(:restaurant).permit(:name)
  end

  def create_params
    params.require(:restaurant).permit(:name)
  end
end
