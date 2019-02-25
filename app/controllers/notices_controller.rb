class NoticesController < ApplicationController
  def index
    @notices = Notice.order_recent.page(params[:page]).per(6)
  end

  def show
    @notice = Notice.find(params[:id])
    @notice.reads_count += 1
    @notice.save
  end

  def new
    authorize Notice.new
  end

  def create
    @notice = Notice.new notice_params
    authorize @notice

    @notice.user = current_user
    if @notice.save
      flash[:success] = '게시되었습니다'
      redirect_to @notice
    else
      errors_to_flash(@notice)
      render :new
    end
  end

  def edit
    @notice = Notice.find(params[:id])
    authorize @notice
  end

  def update
    @notice = Notice.find(params[:id])
    authorize @notice

    @notice.assign_attributes(notice_params)
    if @notice.save
      flash[:success] = '저장되었습니다'
      redirect_to @notice
    else
      errors_to_flash(@notice)
      render :new
    end
  end

  def destroy
    @notice = Notice.find(params[:id])
    authorize @notice

    if @notice.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to notices_path
    else
      errors_to_flash(@notice)
      redirect_to @notice
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :body)
  end
end
