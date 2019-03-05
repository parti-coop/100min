class ErrorsController < ApplicationController

  def not_found
    render status: 404
  end

  def unauthorized
    redirect_to new_user_session_path and return unless user_signed_in?
    render status: 401
  end

  def forbidden
    render status: 403
  end

  def internal_server_error
    render status: 500
  end
end
