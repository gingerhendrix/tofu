class RemoveTvdotcomModels < ActiveRecord::Migration
  def self.up
    drop_table :tvdotcom_episodes
  end

  def self.down
  
  create_table "tvdotcom_episodes", :force => true do |t|
    t.column "number", :integer, :limit => 9, :default => 0, :null => false
    t.column "title", :string, :default => "", :null => false
    t.column "air_date", :datetime, :null => false
    t.column "summary_href", :string, :default => "", :null => false
    t.column "summary", :string, :limit => 1024
    t.column "summary_html", :string, :limit => 1024
    t.column "episode_id", :integer
  end

  add_index "tvdotcom_episodes", ["number", "air_date"], :name => "number", :unique => true
  
  end
end
