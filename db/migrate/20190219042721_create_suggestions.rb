class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.string :title, null: false
      t.text :body
      t.string :image
      t.string :area
      t.string :category
      t.text :raw_hashtags
      t.integer :comments_count, default: 0
      t.integer :reads_count, default: 0
      t.integer :likes_count, default: 0
      t.timestamps null: false
    end
  end
end
