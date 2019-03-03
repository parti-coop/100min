module ApplicationHelper
  def body_class
    dasherized_controller_name = params[:controller].gsub(/\//, '--')
    arr = ["app-#{dasherized_controller_name}", "app-#{dasherized_controller_name}-#{params[:action]}"]
    arr.join(' ')
  end

  def static_day_f(date)
    date.strftime("%Y.%m.%d")
  end
end
