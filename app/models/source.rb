class Source < ActiveRecord::Base
  belongs_to :show
  has_many :updates
  has_one :last_update, :class_name => "Update", :order => "time DESC"
  
  def next_update_time
    if self.last_update 
      self.last_update.time + self.update_interval.minutes
    end
  end
end
