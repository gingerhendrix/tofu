
module CalendarHelper
  def calendar(paginator)
    if paginator.children.length < 10
      for week in paginator.weeks
        yield week
      end
    else
      yield paginator
    end
    
  end


end