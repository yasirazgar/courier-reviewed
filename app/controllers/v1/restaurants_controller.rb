class V1::RestaurantsController < ApplicationController
  before_action :set_restaurant, :set_authorizer, except: :index
  before_action -> { render_unauthorized unless @authorizer.can_access_restaurant?
                   }, except: :index

  def index
    restaurants = current_user.restaurants.pluck(:id, :name)

    render(json: { restaurants: restaurants })
  end

  def show
    posts = @restaurant.posts.pluck(:id, :title, :description)

    render(json: {posts: posts})
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, @restaurant)
  end

end
