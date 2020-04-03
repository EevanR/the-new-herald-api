class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :article_id
      t.integer :user_id
      t.string :email

      t.timestamps
    end
  end
end
