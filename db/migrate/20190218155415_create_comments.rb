class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, index: true
      t.references :commentable, polymorphic: true, index: true, null: false
      t.text :body
      t.integer :likes_count, default: 0
      t.timestamps
    end
  end
end
