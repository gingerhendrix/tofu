class CreateTvrageEpisodes < ActiveRecord::Migration
  def self.up
    create_table :tvrage_episodes do |t|
       t.column :number, :integer
       t.column :short_name, :string
       t.column :season_number, :integer
       t.column :episode_number, :integer
       t.column :date, :date
       t.column :title, :string
       t.column :url, :string
       t.column :show_id, :integer
       t.column :episode_id, :integer
    end
  end

  def self.down
    drop_table :tvrage_episodes
  end
end
