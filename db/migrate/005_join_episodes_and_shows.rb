class JoinEpisodesAndShows < ActiveRecord::Migration
  def self.up
    add_column :episodes, :show_id, :integer
    colbert_report = Show.create :title => "The Colbert Report", :short_name => "colbert"
    Episode.update_all "show_id = #{colbert_report.id}"    
  end

  def self.down
    remove_column :episodes, :show_id
  end
end
