require 'json_web_token'
module RequestsHelper
  def json_post(url, user, params={})
    post(
      url,
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def json_patch(url, user, params={})
    patch(
      url,
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def json_get(url, user, params={})
    get(
      url,
      headers: { "Authorization" => token_for_user(user) },
      params: params)
  end

  def token_for_user(user)
    "Bearer #{JsonWebToken.encode(user_id: user.id)}"
  end

  def assert_access_forbidden
    assert_response :forbidden
    assert_equal(
      I18n.t('authorization.not_allowed'),
      json_response['error']['message'],
      "Should set authorization failure message")
  end
end
