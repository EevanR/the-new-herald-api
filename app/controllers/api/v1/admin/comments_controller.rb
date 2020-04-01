class Api::V1::Admin::CommentsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    comments = Comment.all
    render json: comments
  end

  def create
    comment = Comment.create(comment_params)

    if comment.persisted? 
      render json: comment
    else
      render json: { error: comment.errors.full_messages }, status: 422
    end
  end

  def show
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :article_id, :email, :role)
  end
end
