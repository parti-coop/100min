class SuggestionsController < ApplicationController
  def index
    @suggestions = Suggestion.order_recent.page(params[:page]).per(6)
    if params[:q].present?
      query = params[:q]

      hashtags = Suggestion.parse_hastags(query)
      hashtags.each do |hashtag|
        query = query.gsub(/##{hashtag}/, '')
      end

      if hashtags.any?
        @suggestions = @suggestions.joins(:hashtags).where(hashtags: { name: hashtags })
      end

      if query.present?
        @suggestions = @suggestions.search_for(query)
      end
    end
    if params[:area].present?
      @suggestions = @suggestions.where(area: params[:area])
    end
    if params[:category].present?
      @suggestions = @suggestions.where(category: params[:category])
    end
    if params[:user_id].present?
      @suggestion_user = User.find_by(id: params[:user_id])
      @suggestions = @suggestions.where(user_id: @suggestion_user)
    end
  end

  def show
    @suggestion = Suggestion.find(params[:id])
    @suggestion.reads_count += 1
    @suggestion.save
  end

  def new
    authorize Suggestion.new
  end

  def create
    @suggestion = Suggestion.new suggestion_params
    authorize @suggestion

    @suggestion.user = current_user
    if @suggestion.save
      flash[:success] = '게시되었습니다'
      redirect_to @suggestion
    else
      errors_to_flash(@suggestion)
      render :new
    end

    WordParsingJob.perform_async(@suggestion.id)
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
    authorize @suggestion
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    authorize @suggestion

    @suggestion.assign_attributes(suggestion_params)
    if @suggestion.save
      flash[:success] = '저장되었습니다'
      redirect_to @suggestion
    else
      errors_to_flash(@suggestion)
      render :new
    end
  end

  def destroy
    @suggestion = Suggestion.find(params[:id])
    authorize @suggestion

    if @suggestion.destroy
      flash[:success] = '삭제되었습니다'
      redirect_to suggestions_path
    else
      errors_to_flash(@suggestion)
      redirect_to @suggestion
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:title, :body, :image, :raw_hashtags, :area, :category)
  end
end
