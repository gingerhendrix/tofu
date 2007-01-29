class CreateUpdates < ActiveRecord::Migration
  def self.up
    create_table :updates do |t|
       t.column :source_id, :integer
       t.column :time, :datetime
       t.column :result, :integer
    end
  end

  def self.down
    drop_table :updates
  end
end
