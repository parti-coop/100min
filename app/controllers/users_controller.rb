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
end
