class AddPinToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :pin, :boolean, default: false
  end
end
