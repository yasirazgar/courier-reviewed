class V1::Admin::UsersController < V1::AdminController

  def create
    user = User.create(user_params)
    if user.errors.blank?
      data = { message: I18n.t('user.create.success') }
      render json: data
    else
      data = { message: I18n.t('user.create.failure') }
      render json: data, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
