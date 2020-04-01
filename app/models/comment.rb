class Comment < ApplicationRecord
  validates_presence_of :body
  
  belongs_to :article
  belongs_to :user
end
