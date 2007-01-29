require 'hpricot'
require 'open-uri'

class TvrageSource < Source
 belongs_to :tvrage_show, :class_name => "TvrageShow", :foreign_key => "child_id"
  
 @@tvrage = Tvrage.new 
  
 def self.tvrage= (_tvrage) 
    @@tvrage = _tvrage
 end 
  
  # find a tv show
  def self.find_show(name)
      logger.info "Searching for #{name}"
      searchUrl = @@tvrage.quickinfo name
      logger.info "Retrieving #{searchUrl}"
      info = Hash.new
      open(searchUrl, "Cache-Control" => "no-cache",  "Pragma" => "no-cache") do |f|
        f.each_line do |line|
          pair = line.split("@")
          info[pair[0]] = pair[1].strip
          if pieces = pair[1].strip.match(%r{^(.*)\^(.*)\^(.*)$}) 
            info[pair[0]] = Hash.new
            info[pair[0]][:number] = pieces[1]
            info[pair[0]][:name] = pieces[2]
            info[pair[0]][:date] = Date::strptime(pieces[3], "%b/%d/%Y")  
          end  
        end
      end
      return info
  end
  
  
  #Initialise with remote data
  def init!
    update_episodes
  end
  
  def update
  end
  
  def update_episodes
    @info = parse_episodes
    logger.info "Self.tvrage_show.show #{self.tvrage_show}"
    @info[:episodes].each do |ep|
      #TODO: maybe should only search by date if date-based show format
      #      or could use title as join key?
      episode = Episode.find_or_create :show_id => self.show_id, :episode_date => ep[:date], :season_number => ep[:season_number], :episode_number => ep[:episode_number]
      tvrage_episode = TvrageEpisode.new ep 
      tvrage_episode.episode= episode
      tvrage_episode.show = self.show
      tvrage_episode.save!
    end
    
  end

  def parse_episodes
    episode_url = @@tvrage.episode_list self.tvrage_show.show_url
    logger.info("parse_episodes: Opening #{episode_url}")
    episodesInfo = Hash.new
    doc = Hpricot open(episode_url), :fixup_tags => true
#    
#    seasonsAll =  doc.at('a[@href*=episode_list/all]')  
#    if !seasonsAll.nil?
#      seasons = Array.new
#      seasonsTR = seasonsAll.parent
#      seasonsTR.search('a').each do |a|
#        if a.innerHTML != 'All'
#          seasons << a.innerHTML
#        end
#      end
#    
#    if seasonsTR.at('b > u').innerHTML != 'All'
#          seasons << seasonsTR.at('b > u').innerHTML
#      end  
#      episodesInfo[:seasons] = seasons;
#    else
#      episodesInfo[:seasons] = ['S-1'];
#    end   
   
     
    
    episodeTables = doc.search('table.b')
    episodes = Array.new
   
    episodeTables.each do |table|
      logger.info "Table"
       table.search('tr').each do |row|
        begin
          cols = row.search('td.b1, td.b2')
          logger.info("Row: #{cols.length}  ")
          if cols.length == 4
            ep = Hash.new
            ep[:number] =cols[0].at('a').innerHTML  
            short_name = cols[1].at('a').innerHTML
            ep[:short_name] =short_name
            ids = ep[:short_name].split("x")
            ep[:season_number] =ids[0]
            ep[:episode_number] =ids[1]
            date_string = cols[2].innerText.gsub(/\s/, '')
            if date_string.match(/[0-9]{2}\/[a-zA-Z]{3}\/[0-9]{4}/)
              ep[:date] = Date.strptime date_string, "%d/%b/%Y"
            else
             ep[:date] = nil
            end
            ep[:title] =cols[3].at('a').innerHTML
            ep[:url] ="http://www.tvrage.com" + cols[0].at('a').get_attribute('href')
            logger.info "Adding episode #{episodes.length}  - #{ep[:season_number]}x#{ep[:episode_number]}"
            episodes << ep
          end
        rescue StandardError => e
            logger.warn("Skipping malformed row in #{episode_url} due to #{e}")
        end
      end
    end
    episodesInfo[:episodes] = episodes
    
    return episodesInfo
  end
  
end
