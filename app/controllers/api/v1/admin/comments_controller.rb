class Api::V1::Admin::CommentsController < ApplicationController
  before_action :authenticate_current_user, :except => [:index]

  def index
    comments = Comment.where(article_id: params['article_id'])
    render json: comments
  end

  def create
    comment = Comment.create(comment_params.merge(user_id: current_user.id, email: current_user.email, role: current_user.role))

    if comment.persisted? 
      render json: comment
    else
      render json: { error: comment.errors.full_messages }, status: 422
    end
  end

  def update
    comment = Comment.find(params[:id])
    authorize(comment)
    comment.update(update_params)
    if comment.persisted? 
      render json: comment, status: 200
    else
      render json: { error: comment.errors.full_messages }, status: 422
    end
  end

  def show
  end

  def destroy
    comment = Comment.find(params['id'])
    authorize(comment) 
    comment.destroy
    
    if comment.destroyed?
      render json: { message: "Comment has been deleted" }, status: 200
    else
      render json: { error: comment.errors.full_messages }, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :article_id, :email, :role)
  end

  def update_params
    params.permit(:body)
  end
end
