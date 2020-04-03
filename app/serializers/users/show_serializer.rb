class Users::ShowSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :created_at
end