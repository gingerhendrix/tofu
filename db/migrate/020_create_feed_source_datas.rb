class CreateFeedSourceDatas < ActiveRecord::Migration
  def self.up
    create_table :feed_source_data do |t|
       t.column :feed_source_id, :integer
       t.column :url, :string
    end
  end

  def self.down
    drop_table :feed_source_data
  end
end
