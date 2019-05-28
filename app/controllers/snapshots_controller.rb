class SnapshotsController < ApplicationController
  def index
    redirect_to site_path(code: Suggestion::AREA_DETAIL.first[:code].downcase)
  end

  def show
    @snapshot = Snapshot.find(params[:id])
    @snapshot.reads_count += 1
    @snapshot.save
    @current_area = Suggestion::AREA_CODE[@snapshot.area.to_sym]

    render layout: nil
  end

  def new
    render_404 and return if params[:code].blank?
    @current_area = Suggestion::AREA_CODE[params[:code].upcase.to_sym]

    authorize Snapshot.new
  end

  def create
    @snapshot = Snapshot.new snapshot_params
    authorize @snapshot

    @current_area = Suggestion::AREA_CODE[@snapshot.area.to_sym]
    @snapshot.user = current_user
    if @snapshot.save
      flash[:success] = '게시되었습니다'
      redirect_to site_path(code: @snapshot.area.downcase)
    else
      errors_to_flash(@snapshot)
      render :new
    end
  end

  def edit
    @snapshot = Snapshot.find(params[:id])
    @current_area = Suggestion::AREA_CODE[@snapshot.area.to_sym]
    @snapshot = Snapshot.find(params[:id])
    authorize @snapshot
  end

  def update
    @snapshot = Snapshot.find(params[:id])
    @current_area = Suggestion::AREA_CODE[@snapshot.area.to_sym]
    @snapshot = Snapshot.find(params[:id])
    authorize @snapshot

    @snapshot.assign_attributes(snapshot_params)
    if @snapshot.save
      flash[:success] = '저장되었습니다'
      redirect_to site_path(code: @snapshot.area.downcase)
    else
      errors_to_flash(@snapshot)
      render :new
    end
  end

  def destroy
    @snapshot = Snapshot.find(params[:id])
    @current_area = Suggestion::AREA_CODE[@snapshot.area.to_sym]
    @snapshot = Snapshot.find(params[:id])
    authorize @snapshot

    if @snapshot.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to site_path(code: @snapshot.area.downcase)
    else
      errors_to_flash(@snapshot)
      redirect_to @snapshot
    end
  end

  private

  def snapshot_params
    params.require(:snapshot).permit(:body, :image, :area)
  end
end
