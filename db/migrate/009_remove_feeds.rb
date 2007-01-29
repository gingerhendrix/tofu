class RemoveFeeds < ActiveRecord::Migration
  def self.up
     drop_table :feed_items
  end

  def self.down
    create_table :feed_items do |t|
       t.column :episode_id, :integer
       t.column :torrent_id, :integer
    end
  end
end
