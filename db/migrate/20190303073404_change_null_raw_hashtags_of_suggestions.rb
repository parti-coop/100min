class ChangeNullRawHashtagsOfSuggestions < ActiveRecord::Migration[5.2]
  def change
    change_column_null :suggestions, :raw_hashtags, true
  end
end
