class ChangeSnapshot < ActiveRecord::Migration[5.2]
  def change
    change_column :snapshots, :body, :text
  end
end
