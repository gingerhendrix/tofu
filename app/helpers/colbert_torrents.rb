
module ColbertTorrents
  class ColbertTorrent
    attr_writer "date_added"
    attr_reader "date_added"
    
    attr_writer "episode"
    attr_reader "episode"
    
    attr_writer "url"
    attr_reader "url"
      
    attr_writer "title"
    attr_reader "title"
  
    def to_hash
      return {
        'date_added'  => @date_added,
        'episode_date'  => @episode,
        'url'  => @url,
        'title'  => @title
      }
    end
  
  end
  
  module ColbertFinder
  public
  def ColbertFinder.torrents
    #uri = URI.parse("http://localhost/eclipse/scratch/mininova/colbertreport.htm");
    uri = URI.parse("http://www.mininova.org/search/The+Colbert+Report/added");
    puts "ColbertFinder.torrents #{uri}"
    response = Net::HTTP.get_response(uri);
    body = response.body;
    torrents = Array.new
    body.scan(%r{<tr><td>(.*?)</td><td>.*?</td><td>.*?<a href="/tor/(.*?)">(.*?)</a></td>}m) do |added, url, title|
      added.gsub! "&nbsp;", " "
      date_added = Date::strptime(added, "%d %b %y") #Need better data parsing
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
        episode_date = Date::new(year, dateMatch[1].to_i, dateMatch[2].to_i)
        torrent = ColbertTorrent.new
        torrent.date_added= added
        torrent.episode=  episode_date
        torrent.url= "http://www.mininova.org/get/#{url}"
        torrent.title= title
        torrents.push torrent
      else #no dateMatch
           #skip
      end
      end #scan
      return torrents
   end #def

end #module


end