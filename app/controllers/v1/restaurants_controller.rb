class V1::RestaurantsController < ApplicationController
  before_action :set_restaurant, :set_authorizer, except: :index
  before_action -> { render_unauthorized unless @authorizer.can_access_restaurant?
                   }, except: :index

  def index
    @paginator = Paginator.new(current_user.restaurants, params, :v1_restaurants_url)

    restaurants = @paginator.paginate.pluck(:id, :name)

    render(json: { restaurants: restaurants })
  end

  def show
    @paginator = Paginator.new(@restaurant.posts, params, :v1_restaurant_url)

    posts = @paginator.paginate.pluck(:id, :title, :description)

    data = {
      restaurant: @restaurant.name,
      posts: posts
    }
    render(json: data)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, @restaurant)
  end

end
