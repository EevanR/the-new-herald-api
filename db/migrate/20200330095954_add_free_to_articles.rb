class AddFreeToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :free, :boolean, default: false
  end
end
