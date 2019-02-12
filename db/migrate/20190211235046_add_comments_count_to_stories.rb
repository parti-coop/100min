class AddCommentsCountToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :comments_count, :integer, default: 0
  end
end
