class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
       t.column :type, :string
       t.column :show_id, :integer
    end
    show = Show.find_by_short_name "colbert"
    MininovaSource.create :show_id => show.id
    TvdotcomSource.create :show_id => show.id
  end

  def self.down
    drop_table :sources
  end
end
