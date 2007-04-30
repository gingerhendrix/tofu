class DropEpisodeDateFromTorrents < ActiveRecord::Migration
  def self.up
    remove_column :torrents, :episode_date
  end

  def self.down
    add_column :torrents, :episode_date, :datetime
  end
end
