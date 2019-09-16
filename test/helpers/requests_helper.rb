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

  def json_delete(url, user, params={})
    delete(
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

  def assert_pagination_headers(total_count, current_page=1)
    headers = response.headers

    assert_not_nil headers['Link'], 'Should set pagination links'
    assert_equal(total_count, headers['Total'],
      'Should set total_count')
    assert_equal(current_page, headers['Current-Page'],
      'Should set current_page')
  end
end
