class V1::RepliesController < ApplicationController
  before_action :set_comment, only: :create
  before_action :set_reply, only: [:update, :destroy]

  before_action :set_authorizer
  before_action -> { render_unauthorized unless @authorizer.can_access_comment?
                   }, only: :create
  before_action -> { render_unauthorized unless @authorizer.can_edit_reply?
                   }, only: [:update, :destroy]

  def create
    reply = UserResourcesCreator.new(current_user, @comment).create_reply(create_params)

    if (errors = reply.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { id: reply.id, message: I18n.t('reply.create.success')}
  end

  def update
    @reply.update(update_params)

    if (errors = @reply.errors.full_messages).present?
      render json: { errors: errors.join(', ') }, status: :bad_request
      return
    end

    render json: { message: I18n.t('reply.update.success')}
  end

  def destroy
    @reply.destroy

    render json: { message: I18n.t('reply.destroy.success')}
  end

  private

  def create_params
    params.require(:reply).permit(:body)
  end

  def update_params
    params.require(:reply).permit(:body)
  end

  def set_reply
    @reply = Reply.find(params[:id])
  end

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def set_authorizer
    @authorizer = Authorizer.new(current_user, @comment || @reply)
  end
end
