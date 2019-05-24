class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :text, null: false
      t.integer :count, default: 0
      t.timestamps null: false
    end
  end
end
