class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :prepare_unobtrusive_flash

  include Pundit

  def errors_to_flash(model)
    return if model.errors.empty?
    result ||= ""
    result += model.errors.full_messages.join('<br>')
    flash[:notice] = result.html_safe
  end

  if Rails.env.production? or Rails.env.staging?
    rescue_from ActiveRecord::RecordNotFound, ActionController::UnknownFormat do |exception|
      render_404
    end
    rescue_from ActionController::InvalidCrossOriginRequest, ActionController::InvalidAuthenticityToken do |exception|
      self.response_body = nil
      if request.format.html?
        redirect_to root_url, :alert => I18n.t('errors.messages.invalid_auth_token')
      else
        render_403
      end
    end
  end
  rescue_from Pundit::NotAuthorizedError do |exception|
    policy_name = exception.policy.class.to_s.underscore
    flash[:alert] = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)

    self.response_body = nil
    if request.format.html?
      redirect_to root_url
    else
      render_403
    end
  end

  def render_404
    self.response_body = nil
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: 404 }
      format.js { head 404 }
    end
  end

  def render_403
    self.response_body = nil
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/403.html", layout: false, status: 403 }
      format.js { head 403 }
    end
  end
end
