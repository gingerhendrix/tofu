
module CalendarHelper
  def calendar(paginator, show_frequency)
    # always 20 items ie. max 
    if show_frequency < 2.days
     for week in paginator.weeks
        yield week
      end
    else
       for month in paginator.months
        yield month
      end
    end
    
  end


end