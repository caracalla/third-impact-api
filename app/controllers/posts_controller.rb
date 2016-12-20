class PostsController < ApplicationController
  before_action :require_valid_user, only: [:create]
  before_action -> { require_specific_user_or_admin(post.user) }, only: [:update, :destroy]

  def create
    post = current_user.posts.new(post_params)

    if post.save
      render json: post
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def show
    render json: post
  end

  def index
    if params[:user_id].present?
      render json: User.find(params[:user_id]).posts.order(created_at: :desc)
    else
      render json: Post.all.order(created_at: :desc)
    end
  end

  def update
    if post.update(post_params)
      render json: post
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def destroy
    post.destroy
    render status: 204
  end

  private

  def post_params
    params.require(:post).permit(
      :content,
      :title
    )
  end

  def post
    # Is it okay for this method to return nil?  Should we use `find` instead?
    @post ||= Post.find_by(id: params[:id])
  end
end
