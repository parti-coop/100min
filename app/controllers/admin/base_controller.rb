class Admin::BaseController < ApplicationController
  before_action :admin_only

  private

  def admin_only
    redirect_to root_path if !user_signed_in? or !current_user.admin?
  end
end
