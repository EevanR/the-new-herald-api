class Api::V1::Admin::UsersController < ApplicationController
  before_action :authenticate_current_user

  def show
    user = User.find(params[:id])
    render json: user, serializer: Users::ShowSerializer
  end
  
end