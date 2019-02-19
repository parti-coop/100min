class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.references :suggestion, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :hashtags, [:suggestion_id, :name], unique: true
  end
end
