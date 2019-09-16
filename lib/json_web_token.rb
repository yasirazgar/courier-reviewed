require 'jwt'

class JsonWebToken
  DEFAULT_AUTH_TOKEN_EXP = 30.days.from_now

  def self.encode(payload, exp = DEFAULT_AUTH_TOKEN_EXP)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  rescue
    {}
  end
end
