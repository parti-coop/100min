class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :prepare_unobtrusive_flash
  before_action :prepare_meta_tags, if: -> { request.get? and !Rails.env.test? }

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

  private

  def prepare_meta_tags(options={})
    set_meta_tags build_meta_options(options)
  end

  def build_meta_options(options)
    unless options.nil?
      options.compact!
      options.reverse_merge! default_meta_options
    else
      options = default_meta_options
    end

    current_url = request.url
    og_description = (view_context.strip_tags options[:description]).truncate(160)
    {
      title:       options[:title],
      reverse:     true,
      image:       view_context.asset_url(options[:image]),
      description: options[:description],
      keywords:    options[:keywords],
      canonical:   current_url,
      og: {
        url: current_url,
        title: options[:og_title] || options[:title],
        image: view_context.asset_url(options[:image]),
        description: og_description,
        type: 'website'
      }
    }.reject{ |_,v| v.nil? }
  end

  def default_meta_options
    {
      title: "100년 토론광장",
      description: "100년 전, 선조들이 꿈꾸었던 나라를 현실로 만들려면, 지금 우리는 무엇을 해야 할까요?
어떤 문제를 어떻게 해결해야 할까요? 100년 전의 꿈을 현실로 만들 실천과제를 토론해 봅시다.",
      keywords: "삼일운동, 정치, 민주주의, 공론장",
      image: view_context.asset_url("@thumb_news.jpg"),
      twitter_card_type: "summary_card"
    }
  end
end
