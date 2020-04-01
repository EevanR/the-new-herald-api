class Article < ApplicationRecord
  validates_presence_of :title, :body
  translates :title, :body
  globalize_accessors locales: [:en, :sv], attributes: [:title, :body]
  
  belongs_to :journalist, class_name: 'User'
  belongs_to :publisher, class_name: 'User', optional: true

  has_one_attached :image

  enum category: [:news, :food, :tech, :culture, :sports, :misc]

  has_many :comments

  def unpublish
    if self.published_before_last_save == true && self.published == false
      self.update(publisher: nil)
    end
    return true
  end
end