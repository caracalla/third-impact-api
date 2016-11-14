class CommentsController < ApplicationController
  before_action :require_valid_user, except: [:create]
  before_action -> { require_specific_user_or_admin(comment.user) }, only: [:update, :destroy]

  def create
    comment = current_user.comments.new(comment_params)

    if comment.save
      render json: comment
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  def show
    if comment.present?
      render json: comment
    else
      render status: 404
    end
  end

  def index
    if params[:post_id].present?
      render json: Post.find(params[:post_id]).comments
    elsif params[:user_id].present?
      render json: User.find(params[:user_id]).comments
    else
      render status: 404
    end
  end

  def update
    if comment.update(comment_params)
      render json: comment
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  def destroy
    comment.destroy
    render status: 204
  end

  private

  def comment_params
    params.require(:comment).permit(
      :content,
      :post_id
    )
  end

  def comment
    @comment ||= Comment.find_by(id: params[:id])
  end
end
