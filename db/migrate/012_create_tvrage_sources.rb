class CreateTvrageSources < ActiveRecord::Migration
  def self.up
    create_table :tvrage_sources do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :tvrage_sources
  end
end
