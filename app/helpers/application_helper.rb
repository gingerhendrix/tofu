# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 def display_episode(ep)
    "#{ep[:name]} (#{ep[:number]} - #{ep[:date].strftime('%d %b %y')})"
  end
end
