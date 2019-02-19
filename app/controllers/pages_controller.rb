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

    @stories = Story.order_recent.limit(4)
  end

  def faq
    @faqs = Faq::DATA
  end
end
