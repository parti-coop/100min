class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :title, null: false
      t.text :body
      t.string :image
      t.integer :reads_count, default: 0
      t.integer :likes_count, default: 0
      t.timestamps null: false
    end
  end
end
