class AddPictureToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :picture, :string
  end
end
