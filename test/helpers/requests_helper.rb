require 'json_web_token'
module RequestsHelper
  def json_post(url, params, user)
    post(
      send(url, format: :json),
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def json_patch(url, params, user)
    patch(
      send(url, format: :json),
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def json_get(url, params, user)
    get(
      send(url, format: :json),
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def token_for_user(user)
    "Bearer #{JsonWebToken.encode(user_id: user.id)}"
  end
end
