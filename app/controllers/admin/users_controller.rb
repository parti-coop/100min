class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order_recent.page(params[:page]).per(50)
    if params[:q].present?
      query = params[:q]
      if query.present?
        @users = @users.search_for(query)
      end
    end
  end
end
