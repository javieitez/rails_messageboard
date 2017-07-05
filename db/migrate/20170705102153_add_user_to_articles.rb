class AddUserToArticles < ActiveRecord::Migration[5.1]
  def change
    add_index :articles, [:user_id, :created_at]
  end
end
