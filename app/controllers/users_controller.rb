class UsersController < ApplicationController
  before_action :require_valid_user, except: [:create, :show]
  before_action -> { require_specific_user_or_admin(user) }, only: [:update, :destroy]

  def create
    user = User.new(user_params)

    if user.save
      login!(user)
      render json: user, serializer: User::AuthenticationSerializer
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def show
    if user.present?
      render json: user
    else
      render status: 404
    end
  end

  def index
    render json: User.all
  end

  def update
    if user.update(user_params)
      render json: user
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user.destroy
    render status: 204
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password
    )
  end

  def user
    @user ||= User.find_by(id: params[:id])
  end
end
