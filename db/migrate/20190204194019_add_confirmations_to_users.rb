class AddConfirmationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirmation_terms, :boolean, default: false
    add_column :users, :confirmation_privacy, :boolean, default: false
    add_column :users, :confirmation_mailing, :boolean, default: false
  end
end
