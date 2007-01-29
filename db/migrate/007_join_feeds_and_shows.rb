class JoinFeedsAndShows < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :show_id, :integer
    show = Show.find_by_short_name "colbert"
    FeedItem.find(:all).each do |item|
      item.show = show
      item.save!
    end
  end

  def self.down
    remove_column :feeds, :show_id
  end
end
