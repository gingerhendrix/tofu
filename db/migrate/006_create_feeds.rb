class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
       t.column :episode_id, :integer
       t.column :torrent_id, :integer
    end
    feed = Torrent.find :all, :order => 'episode_date DESC, title',
                          :conditions => "num=0",
                          :limit  =>  5
    feed.each do |t|
      i = FeedItem.create 
      i.episode = t.episode
      i.torrent = t
      i.save!
    end                          
  end

  def self.down
    drop_table :feed_items
  end
end
