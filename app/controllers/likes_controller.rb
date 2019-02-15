class LikesController < ApplicationController
  def create
    render_404 and return unless user_signed_in?

    likable = params[:likable_type].try(:safe_constantize).try(:find, params[:likable_id])
    render_404 and return if likable.blank?

    likable.likes.create(user: current_user)
    redirect_to likable
  end

  def destroy_by_current_user
    render_404 and return unless user_signed_in?

    likable = params[:likable_type].try(:safe_constantize).try(:find, params[:likable_id])
    render_404 and return if likable.blank?

    likable.likes.find_by(user: current_user).destroy
    redirect_to likable
  end
end
