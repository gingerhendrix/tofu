
class MininovaSource < Source
  
  @@server = MininovaServer.new
  
  def self.server=s
    @@server = s    
  end
  
  def init
      _update
  end
  
  def update
    _update
  end
  
  def parse_torrents
    search_url = URI.parse URI.escape( @@server.search(self.show.title))
    response = Net::HTTP.get_response(search_url);
    body = response.body;
    #logger.info "Body: #{body}"
    torrents = Array.new
    body.scan(%r{<tr><td>(.*?)</td><td>.*?</td><td>.*?<a href="/tor/(.*?)">(.*?)</a></td>}m) do |added, url, title|
      added.gsub! "&nbsp;", " "
      date_added = Date::strptime(added, "%d %b %y") 
      torrent = Hash.new
      torrent[:date_added]= added
      torrent[:url] = "http://www.mininova.org/get/#{url}"
      torrent[:title] = title
      torrents.push torrent
    end #scan
    return torrents
  end
  
  def _update
    logger.info "UPDATE"
    torrents = parse_torrents
    count = 0
    torrents.each do |t|
      logger.info "Processing torrent #{t[:title]}"
      if Torrent.count(["url = ?", t[:url]]) == 0
        episode = _find_episode t[:title]
        logger.info "Episode: #{episode.nil? ? 'nil' : episode[:id]}"
        if !episode.nil?
          duplicateCount = episode.torrents.length
          torrent = Torrent.new t
          torrent.episode = episode;
          if duplicateCount>0
            torrent.num = duplicateCount
          end
          torrent.save
          count += 1
        end
        #Create torrent
      end
    end
    return count
  end
  
  def _find_episode(title)
    date = _extract_date title
    logger.info "Date: #{date}"
    episode = nil
    if !date.nil? 
      episode = Episode.find :first, :conditions => "show_id = #{self[:show_id]} AND TO_DAYS(episode_date) = TO_DAYS('#{date}')"
    else
      season, ep = _extract_episode title
      if season!=0 && episode!=0
         episode = Episode.find :first, :conditions => "show_id = #{self[:show_id]} AND season_number = #{season} AND episode_number = #{ep}"
      end
    end
  end
  
  def _extract_episode(title)
    match = title.match(%r{S(\d+)\s*E(\d+)})
    if match
      return [match[1].to_i, match[2].to_i]
    else
      match = title.match(%r{(\d+)x(\d+)})
      if match
        return [match[1].to_i, match[2].to_i]
      end
     end
    return [0, 0]
  end
  
  def _extract_date(title)
    sep = "(?:\.|\s|-)"
    dateMatch = title.match(%r{\s+(\d{2})#{sep}(\d{2})#{sep}(\d{2})\s+})
    if dateMatch 
      year = dateMatch[3].to_i;
      if year < 100 
        if year < 69
          year += 2000
        else
          year += 1900
        end
      end
      return episode_date = Date::new(year, dateMatch[1].to_i, dateMatch[2].to_i)
    else
      return nil
    end
  end
  
end