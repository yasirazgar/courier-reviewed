class V1::AdminController < ApplicationController
  before_action :require_admin_access

  private

  def require_admin_access
    return true if @current_user.admin?

    render_unauthorized
  end
end
