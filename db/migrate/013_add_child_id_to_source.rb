class AddChildIdToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :child_id, :integer
  end

  def self.down
    remove_column :sources, :child_id
  end
end
