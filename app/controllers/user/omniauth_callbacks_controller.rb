# frozen_string_literal: true

class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  prepend_before_action :require_no_authentication, only: [:facebook, :google_oauth2, :twitter, :kakao, :naver]

  def google_oauth2
    run_omniauth
  end

  def twitter
    run_omniauth
  end

  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email" and return
    end

    run_omniauth
  end

  def naver
    run_omniauth
  end

  def kakao
    run_omniauth
  end

  def failure
    redirect_to root_path
  end

  def failure
    logger.fatal "Omniauth Fail : kind: OmniAuth::Utils.camelize(failed_strategy.try(:name)), reason: #{failure_message}"
    logger.fatal "Omniauth Env : #{request.env.inspect}"

    set_flash_message(:notice, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.try(:name)),
      reason: failure_message) if is_navigational_format?
    redirect_to root_path
  end

  private

  def run_omniauth
    parsed_data = User.parse_omniauth(request.env["omniauth.auth"])
    remember_me = request.env["omniauth.params"].try(:fetch, "remember_me", false)
    parsed_data[:remember_me] = remember_me

    @user = User.find_or_initialize_for_omniauth(parsed_data)
    if @user.new_record?
      if @user.save
        set_flash_message(:notice, :success, kind: @user.provider) if is_navigational_format?
      else
        set_flash_message(:notice, :failure, kind: @user.provider, reason: @user.errors.full_messages.to_sentence) if is_navigational_format?
        redirect_to root_path and return
      end
    else
      @user.remember_me = remember_me
      set_flash_message(:notice, :success, kind: @user.provider) if is_navigational_format?
    end
    sign_in_and_redirect @user, :event => :authentication
  end
end
