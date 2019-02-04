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
    parsed_data = User.parse_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

    @user = User.find_or_initialize_for_omniauth(parsed_data)
    if @user.new_record?
      param_refer_from = request.env["omniauth.params"].try(:fetch, "refer_from", '')
      if param_refer_from == 'sign_in'
        flash[:notice] = '아직 회원으로 가입하지 않으셨네요. 회원가입을 진행하기 위해 약관에 동의하세요.'
        redirect_to new_user_registration_path
        return
      end
      if @user.save
        set_flash_message(:notice, :success, kind: @user.provider) if is_navigational_format?
        sign_in_and_redirect @user, :event => :authentication
        return
      else
        if @user.errors.keys.include?(:confirmation)
          flash[:notice] = '회원가입을 진행하기 전에 약관에 동의하세요.'
          redirect_to new_user_registration_path
        else
          set_flash_message(:notice, :failure, kind: @user.provider, reason: @user.errors.full_messages.to_sentence)
          redirect_to root_path
        end
        return
      end
    else
      set_flash_message(:notice, :success, kind: @user.provider)
      sign_in_and_redirect @user, :event => :authentication
      return
    end
  end
end
