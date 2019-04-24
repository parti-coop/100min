class CreateKommentable < ActiveRecord::Migration[5.2]
  def change
    create_table :kommentables do |t|
      t.integer :comments_count, default: 0
      t.string :slug, null: false
      t.timestamps null: false
    end

    add_index :kommentables, :slug, unique: true
  end
end
