require 'json_web_token'

class V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      jwt = JsonWebToken.encode(user_id: user.id)

      render json: {
        user: user.slice(:username, :email),
        jwt: jwt,
        message: I18n.t('authentication.success')}
    else
      render json: {
        error: I18n.t('authentication.failure')
      }, status: 401
    end
  end
end
