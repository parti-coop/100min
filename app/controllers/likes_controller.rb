class LikesController < ApplicationController
  def create
    render_404 and return unless user_signed_in?

    @likable = params[:likable_type].try(:safe_constantize).try(:find, params[:likable_id])
    render_404 and return if @likable.blank?

    @likable.likes.create(user: current_user)

    respond_to do |format|
      format.html { redirect_to @likable }
      format.js
    end
  end

  def destroy
    render_404 and return unless user_signed_in?

    @likable = params[:likable_type].try(:safe_constantize).try(:find, params[:likable_id])
    render_404 and return if @likable.blank?

    @likable.likes.find_by(user: current_user).try(:destroy)

    respond_to do |format|
      format.html { redirect_to @likable }
      format.js
    end
  end
end
