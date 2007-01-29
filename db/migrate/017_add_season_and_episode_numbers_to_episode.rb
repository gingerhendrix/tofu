class AddSeasonAndEpisodeNumbersToEpisode < ActiveRecord::Migration
  def self.up
    add_column :episodes, :season_number, :integer
    add_column :episodes, :episode_number, :integer
  end

  def self.down
    remove_column :episodes, :season_number
    remove_column :episodes, :episode_number
  end
end
