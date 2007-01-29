class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
       t.column :title, :string
       t.column :short_name, :string
    end
  end

  def self.down
    drop_table :shows
  end
end
