class RemoveTvrageSources < ActiveRecord::Migration
  def self.up
     drop_table :tvrage_sources
  end

  def self.down
    create_table :tvrage_sources do |t|
      # t.column :name, :string
    end
  end
end
