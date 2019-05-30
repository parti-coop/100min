class ChangeAreaToAreaCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :suggestions, :area, :area_code
    rename_column :snapshots, :area, :area_code
  end
end
