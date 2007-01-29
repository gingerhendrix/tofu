class AddUpdateInterval < ActiveRecord::Migration
  def self.up
    add_column :sources, :update_interval, :integer
    Source.find(:all).each do |s|
      s.update_interval = 60 #Interval is in minutes, default is one hour
      s.save
    end    
  end

  def self.down
    remove_column :sources, :update_interval
  end
end
