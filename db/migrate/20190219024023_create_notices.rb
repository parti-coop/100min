class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :title, null: false
      t.text :body
      t.integer :comments_count, default: 0
      t.integer :reads_count, default: 0
      t.integer :likes_count, default: 0
      t.timestamps null: false
    end
  end
end
