class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :likable, polymorphic: true, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps
    end

    # add_index :likes, [:likable_type, :likable_id, :user_id], unique: true
  end
end
