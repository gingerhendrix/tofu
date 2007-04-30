# A singleton for accessing services provided by  TvRage

class Tvrage
  
  def quickinfo(name)
    "http://www.tvrage.com/quickinfo.php?show=#{name}"
  end
  
  def episode_list(url, season=nil)
    if season.nil?
      return url + "/episode_list"
    else
      return url + "/episode_list/" + season
    end
  end

end