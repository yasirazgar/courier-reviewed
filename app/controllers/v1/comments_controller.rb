class V1::CommentsController < ApplicationController
  before_action :set_post, only: [:index, :create]
  before_action :set_comment, only: [:show, :update, :destroy]

  before_action :set_authorizer
  before_action -> { render_unauthorized unless @authorizer.can_access_post?
                   }, only: [:index, :create]
  before_action -> { render_unauthorized unless @authorizer.can_access_comment?
                   }, only: :show
  before_action -> { render_unauthorized unless @authorizer.can_edit_comment?
                   }, only: [:update, :destroy]

  def index
    @paginator = Paginator.new(@post.comments, params, :v1_post_comments_url)

    comments = @paginator.paginate.pluck(:id, :user_id, :body)

    render json: { comments: comments }
  end

  def show
    @paginator = Paginator.new(@comment.replies, params, :v1_comment_url)
    replies = @paginator.paginate.pluck(:id, :user_id, :body)

    data = {
      comment: @comment.body,
      replies: replies
    }
    render json: data
  end

  def create
    comment = UserResourcesCreator.new(current_user, @post).create_comment(create_params)

    if (errors = comment.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { id: comment.id, message: I18n.t('comment.create.success')}
  end

  def update
    @comment.update(update_params)

    if (errors = @comment.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { message: I18n.t('comment.update.success')}
  end

  def destroy
    @comment.destroy

    render json: { message: I18n.t('comment.destroy.success')}
  end

  private

  def create_params
    params.require(:comment).permit(:body)
  end

  def update_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, @post || @comment)
  end
end
