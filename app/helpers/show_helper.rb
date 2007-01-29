require 'generator'

module ShowHelper
  def weekTitle(week)
    if (Time.now > week.beginning && Time.now < (week.beginning + 7.days))
      "This week"
    elsif ((Time.now+7.days) > week.beginning && (Time.now + 7.days) < (week.beginning + 7.days))
      "Next week"
    elsif ((Time.now-7.days) > week.beginning && (Time.now - 7.days) < (week.beginning + 7.days))
      "Last week"
    else
      "" + week.beginning.strftime("%d %b %y") + " - " + (week.beginning + 6.days).strftime("%d %b %y")
    end
  end
end #FilterHelper
