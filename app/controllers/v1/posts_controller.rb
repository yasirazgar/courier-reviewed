class V1::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_restaurant, only: :create

  before_action :set_authorizer, except: :index
  before_action -> { render_unauthorized unless @authorizer.can_access_post?
                   }, only: :show
  before_action -> { render_unauthorized unless @authorizer.can_edit_post?
                   }, only: [:update, :destroy]
  before_action -> { render_unauthorized unless @authorizer.can_access_restaurant?
                   }, only: :create

  def index
    posts = current_user.posts.includes(:restaurant)

    @paginator = Paginator.new(posts, params, :v1_posts_url)

    posts = @paginator.paginate.pluck(:id, 'restaurants.name', :title, :description)
    render json: { posts: posts }
  end

  def show
    data = {
      post: [@post.title, @post.description],
      comments: @post.comments.includes(:user).limit(Post::COMMENTS_COUNT_TO_DISPLAY).pluck(:id, 'users.id', :body)
    }

    render json: data
  end

  def create
    post = UserResourcesCreator.new(current_user, @restaurant).create_post(create_params)

    if (errors = post.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { id: post.id, message: I18n.t('post.create.success')}
  end

  def update
    @post.update(update_params)

    if (errors = @post.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { message: I18n.t('post.update.success') }
  end

  def destroy
    @post.destroy

    render json: { message: I18n.t('post.destroy.success')}
  end

  private

  def create_params
    params.require(:post).permit(:title, :description)
  end

  def update_params
    params.require(:post).permit(:title, :description)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, (@restaurant || @post))
  end

end
