class JoinTorrentAndEpisodes < ActiveRecord::Migration
  def self.up
    add_column :torrents, :episode_id, :integer
    Torrent.find(:all).each do |t|
      episode = Episode.find_by_episode_date t.episode_date
      episode = Episode.create :episode_date => t.episode_date unless episode
      t.episode = episode
      t.save      
    end 
  end

  def self.down
    remove_column :torrents, :episode_id
  end
end
