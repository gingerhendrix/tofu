class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table "episodes" do |t|
      t.column "episode_date", :datetime, :null => false
    end
  end

  def self.down
    drop_table "episodes"
  end
end
