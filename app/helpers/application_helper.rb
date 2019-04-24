module ApplicationHelper
  def body_class
    dasherized_controller_name = params[:controller].gsub(/\//, '--')
    arr = ["app-#{dasherized_controller_name}", "app-#{dasherized_controller_name}-#{params[:action]}"]
    arr.join(' ')
  end

  def static_day_f(date)
    date.strftime("%Y.%m.%d")
  end

  def human_datetime_f(date)
    date.strftime("%Y년 %m월 %d일 %H:%M")
  end
end
