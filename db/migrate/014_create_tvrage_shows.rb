class CreateTvrageShows < ActiveRecord::Migration
  def self.up
    create_table :tvrage_shows do |t|
       t.column :show_name, :string
       t.column :show_url, :string
    end
  end

  def self.down
    drop_table :tvrage_shows
  end
end
