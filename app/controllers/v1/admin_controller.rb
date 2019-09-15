class V1::AdminController < ApplicationController
  before_action :require_admin_access

  private

  def require_admin_access
    return true if @current_user.admin?

    render json: {
        error: I18n.t('authentication.failure')
      }, status: 403
  end
end
