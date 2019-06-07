class UsersController < ApplicationController
  def cancel
    redirect_to :root_path and return unless user_signed_in?

    if current_user.destroy
      sign_out current_user
      flash[:success] = '탈퇴되었습니다. 다음에 다시 만나요.'
    else
      flash[:error] = '탈퇴 중에 오류가 발생했습니다. 잠시 후에 다시 시도해 주세요.'
    end

    redirect_to root_path
  end

  def confirm_form
  end

  def confirm
    render_404 and return unless user_signed_in?

    current_user.confirmation_terms = (params[:confirmation_terms] == "y")
    current_user.confirmation_privacy = (params[:confirmation_privacy] == "y")
    current_user.confirmation_mailing = (params[:confirmation_mailing] == "y")
    current_user.save

    flash[:success] = '가입이 완료되었습니다.'
    redirect_to after_sign_in_path_for(current_user)
  end
end
