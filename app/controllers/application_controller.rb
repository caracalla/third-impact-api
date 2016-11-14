class ApplicationController < ActionController::API
  # before_action :artificial_delay
  before_action :authenticate

  def login!(user)
    @current_user = user
    # session[:session_token] = user.session_token
  end

  def logout!
    current_user.try(:reset_tokens)
    # session[:session_token] = nil
  end

  def current_user
    # return nil if session[:session_token].nil?

    # @current_user ||= User.find_by(session_token: session[:session_token])

    return nil unless valid_auth_token?

    @current_user ||= User.find_by(email: request.headers["X-Auth-Email"])
  end

  def require_valid_user
    if current_user.nil?
      render json: { errors: ["Invalid credentials"] }, status: 401
      logout!
    end
  end

  def authenticate
    # The client has attempted to authenticate the request.  If the authentication is
    # invalid, reset the user's tokens and notify the client to log the user out.
    if request.headers.key?("X-Auth-Token")
      require_valid_user
    end
  end

  def valid_auth_token?
    if request.headers.key?("X-Auth-Email")
      user = User.find_by(email: request.headers["X-Auth-Email"])

      if user.present? && user.auth_token == request.headers["X-Auth-Token"]
        return true
      end
    end

    return false
  end

  def require_specific_user_or_admin(user)
    render status: 403 unless current_user == user || current_user.try(:admin?)
  end

  def artificial_delay
    sleep(0.5)
  end
end
