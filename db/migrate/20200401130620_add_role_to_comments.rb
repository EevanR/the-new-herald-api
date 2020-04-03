class AddRoleToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :role, :string
  end
end
