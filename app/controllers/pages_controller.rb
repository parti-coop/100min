class PagesController < ApplicationController
  def home
    @suggestion_new = Suggestion.order_recent.first
    if Suggestion.past_week.count > 10
      @suggestions = Suggestion.past_week
    else
      @suggestions = Suggestion.all
    end
    @suggestions = @suggestions.where.not(id: @suggestion_new.try(:id)).order_hot.limit(2)

    @notices = Notice.order_recent.limit(3)

    @faqs = Faq::DATA[0..2]

    @pin_story = Story.order_recent.where(pin: true).first
    @stories = ([@pin_story] << Story.order_recent.where.not(id: @pin_story).limit(4).to_a).flatten
    @stories.compact!
    @stories = @stories[0..3]
  end

  def faq
    @faqs = Faq::DATA
  end

  def about
  end

  def caution
  end

  def map
  end

  def group
  end

  def privacy
  end

  def terms
  end

  def site
    @current_area = Suggestion::AREA_CODE[params[:area_code].upcase.to_sym]
    @snapshots = Snapshot.order_recent.where(area_code: @current_area.try(:fetch, :code)).page(params[:page]).per(6)
    if params[:q].present?
      query = params[:q]
      if query.present?
        @snapshots = @snapshots.search_for(query)
      end
    end
    if params[:user_id].present?
      @snapshot_user = User.find_by(id: params[:user_id])
      @snapshots = @snapshots.where(user_id: @snapshot_user)
    end

    if params[:snapshot_id].present?
      @current_snapshot = Snapshot.find_by(id: params[:snapshot_id])
    end
  end

  def application
    redirect_to 'http://bit.ly/백년토론광장'
  end
end
