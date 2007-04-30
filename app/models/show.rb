
class Show < ActiveRecord::Base
  has_many :episodes
  
  has_one :latest_episode, :class_name => "Episode", :order => "episode_date DESC", :conditions => "episode_date < '#{Time.now.strftime('%Y:%m:%d %H:%M')}'"
  has_one :next_episode, :class_name => "Episode", :order => "episode_date ASC", :conditions => "episode_date > '#{Time.now.strftime('%Y:%m:%d %H:%M')}'"
  has_one :first_episode, :class_name => "Episode", :order => "episode_date ASC"
  #has_many :feed_items
  has_many :sources
  
  has_many :tvrage_episodes

  def recent_episodes
    self.episodes.find :all, :limit => 20,
                  :order => "episode_date DESC", 
                  :conditions => "episode_date < '#{Time.now.strftime('%Y:%m:%d %H:%M')}'  AND episode_date > '#{(Time.now - 2.months).strftime('%Y:%m:%d %H:%M')}'" 
    end
  
  def episodes_by_week (start_week=0, weeks_per_page=5)
        weeks_end = (Time.now.beginning_of_week  - start_week.weeks + 1.weeks)
        weeks_start = weeks_end - weeks_per_page.weeks
                 
        weeks_end_string = weeks_end.strftime("%Y:%m:%d %H:%M")
        weeks_start_string = weeks_start.strftime("%Y:%m:%d %H:%M")
        
        @items = episodes.find :all, :order => "episode_date DESC", 
                           :conditions => "episode_date > '#{weeks_start_string}' AND episode_date < '#{weeks_end_string}'"
  end
  
  def feed
    dateLimit = (self.latest_episode.episode_date - 1.weeks).strftime('%Y:%m:%d %H:%M')
    puts "dateLimit #{dateLimit}"
    feed = Torrent.find :all, :order => 'episodes.episode_date DESC, torrents.title',
                        :conditions => "episodes.episode_date > '#{dateLimit}' AND episodes.show_id=#{self.id} AND torrents.num=0 ",
                        :limit  =>  5,
                        :include => :episode
  end
  
  def frequency
    episodes = self.episodes.find :all, :limit => 5, :order => "episode_date DESC", 
                  :conditions => "episode_date < '#{Time.now.strftime('%Y:%m:%d %H:%M')}'"
    n=0;
    d1=nil;
    sum =0;
    episodes.each do |e|
      d2 = d1
      d1 = e.episode_date
      if !d2.nil?
        diff = d2 - d1
        sum += diff
        n+=1;
     end
    end
    if n>0
      frequency = sum/n
     else
      frequency = nil
     end    
    return frequency;              
  end
end
