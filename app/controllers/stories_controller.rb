class StoriesController < ApplicationController
  def index
    @stories = Story.order_recent.page(params[:page]).per(6)
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    authorize Story.new
  end

  def create
    @story = Story.new story_params
    authorize @story

    if @story.save
      redirect_to @story
    else
      errors_to_flash(@story)
      render :new
    end
  end

  def edit
    @story = Story.find(params[:id])
    authorize @story
  end

  def update
    @story = Story.find(params[:id])
    authorize @story

    @story.assign_attributes(story_params)
    if @story.save
      flash[:success] = '저장되었습니다'
      redirect_to @story
    else
      errors_to_flash(@story)
      render :new
    end
  end

  def destroy
    @story = Story.find(params[:id])
    authorize @story

    if @story.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to stories_path
    else
      errors_to_flash(@story)
      render :new
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :body, :image)
  end
end