class JoinTvdotcomAndEpisodes < ActiveRecord::Migration
  def self.up
    add_column :tvdotcom_episodes, :episode_id, :integer
    TvdotcomEpisode.find(:all).each do |e|
      episode = Episode.find_by_episode_date e.air_date
      episode = Episode.create :episode_date => e.air_date unless episode
      e.episode = episode
      e.save      
    end 
  end

  def self.down
    remove_column :tvdotcom_episodes, :episode_id
  end
end
