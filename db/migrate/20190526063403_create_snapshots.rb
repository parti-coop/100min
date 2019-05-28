class CreateSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :snapshots do |t|
      t.string :image, null: false
      t.string :body, null: false
      t.string :area, null: false
      t.integer :comments_count, default: 0
      t.integer :reads_count, default: 0
      t.integer :likes_count, default: 0
      t.references :user, null: false, index: true
      t.string :real_user_name
      t.timestamps null: false
    end
  end
end
