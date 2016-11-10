class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      render json: { message: "Invalid credentials" }, status: 401
    else
      login!(user)
      render json: user
    end
  end

  def destroy
    logout!
    render status: 204
  end
end