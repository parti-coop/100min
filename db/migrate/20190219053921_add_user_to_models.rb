class AddUserToModels < ActiveRecord::Migration[5.2]
  def change
    add_reference :stories, :user, index: true
    add_reference :notices, :user, index: true
    add_reference :suggestions, :user, index: true

    user = User.first
    Story.update_all(user_id: user.id)
    Notice.update_all(user_id: user.id)
    Suggestion.update_all(user_id: user.id)

    change_column_null :stories, :user_id, false
    change_column_null :notices, :user_id, false
    change_column_null :suggestions, :user_id, false
  end
end
