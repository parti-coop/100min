class RemoveNullUserComments < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do
      Comment.all.each do |comment|
        comment.destroy unless User.exists?(comment.user_id)
      end
    end
  end
end
