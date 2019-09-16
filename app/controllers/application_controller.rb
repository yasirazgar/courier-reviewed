class ApplicationController < ActionController::API
  before_action :authenticate_request
  after_action :setup_page_headers

  def render_unauthorized
    render(:json => {
        :error => {:message => I18n.t('authorization.not_allowed')}
      },
      :status => 403)
  end

  private

  def setup_page_headers
    return unless @paginator

    headers['Link'] = @paginator.header_links
    headers['Total'] = @paginator.total_count
    headers['Current-Page'] = @paginator.page
  end

  def authenticate_request
    unless current_user
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_user
    @current_user ||= fetch_user_from_token
  end

  def fetch_user_from_token
    (token = jwt.presence) &&
    (user_id = JsonWebToken.decode(token)[:user_id]) &&
    (User.find_by_id(user_id))
  end

  def jwt
    # request.env["HTTP_AUTHORIZATION"].scan(/Bearer  (.*)$/).flatten.last
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    end
  end
end
