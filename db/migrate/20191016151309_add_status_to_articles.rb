class AddStatusToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :status, :integer, default: 0, null: false, limit: 1
  end
end
