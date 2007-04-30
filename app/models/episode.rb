class Episode < ActiveRecord::Base
  has_one :tvrage_episode
  has_many :torrents
  belongs_to :show
  #belongs_to :feed_item
  
  def info
    info = Hash.new
    info[:date] = self.episode_date
    info[:season] = self.season_number
    info[:episode] = self.episode_number
    if !self.tvrage_episode.nil?
      info[:title] = self.tvrage_episode.title
    end
    return info            
  end
end
