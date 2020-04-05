class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  before_action :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def not_authorized 
    render json: { error: I18n.t('errors.not_authorized')}, status: 404
  end 

  def authenticate_current_user
    if get_current_user.nil?
      # head :unauthorized 
      render json: { errors: [I18n.t('errors.unauthenticated')]}, status: 401
    end
  end

  def get_current_user
    if request.headers['access-token'].nil? or request.headers['client'].nil? or request.headers['uid'].nil?
      return nil
    end

    current_user = User.find_by(uid: request.headers['uid'])

    if current_user && current_user.tokens.has_key?(request.headers["client"])
        token = current_user.tokens[request.headers["client"]]
        expiration_datetime = DateTime.strptime(token["expiry"].to_s, "%s")

        expiration_datetime > DateTime.now
        @current_user = current_user
    end

    @current_user
  end


  protected

  def article_not_found
    render json: { error: I18n.t('errors.article_not_found')}, status: 404
  end

  def meta_attributes(resource)    
    {
      current_page: resource.current_page,
      next_page: resource.next_page,
      prev_page: resource.previous_page,
      total_pages: resource.total_pages,
      total_count: resource.total_entries,
    }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
