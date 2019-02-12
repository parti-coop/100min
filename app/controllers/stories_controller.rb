class StoriesController < ApplicationController
  def index
    @stories = Story.order_recent.page(params[:page]).per(6)
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
  end

  def create
    @story = Story.new story_params
    authorize @story

    if @story.save
      redirect_to stories_path
    else
      render :new
    end
    errors_to_flash(@story)
  end

  private

  def story_params
    params.require(:story).permit(:title, :body, :image)
  end
end
