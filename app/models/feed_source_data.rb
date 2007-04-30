class FeedSourceData < ActiveRecord::Base
  set_table_name 'feed_source_data'
  belongs_to :feed_source  

end
