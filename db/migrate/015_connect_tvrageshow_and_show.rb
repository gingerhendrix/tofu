class ConnectTvrageshowAndShow < ActiveRecord::Migration
  def self.up
    add_column :tvrage_shows, :show_id, :integer
  end

  def self.down
    remove_column :tvrage_shows, :show_id
  end
end
