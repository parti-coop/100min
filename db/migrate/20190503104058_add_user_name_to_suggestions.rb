class AddUserNameToSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :real_user_name, :string
  end
end
