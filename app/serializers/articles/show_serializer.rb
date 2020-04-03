class Articles::ShowSerializer < ActiveModel::Serializer
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :image, :category, :location, :journalist, :created_at

  def body
    if !current_user.nil? && !current_user.role.nil?
      object.body
    else
      truncate(object.body, length: 350)
    end
  end

  def image
    if object.image.attachment.nil?
      object.image = nil
    else
      if Rails.env.test?
        rails_blob_url(object.image, only_path: true)
      else
        object.image.service_url(expires_in: 1.hours, disposition: 'inline')
      end
    end
  end

  def journalist
    object.journalist.uid
  end
end