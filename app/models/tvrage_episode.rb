class TvrageEpisode < ActiveRecord::Base
  belongs_to :episode
  belongs_to :show
  
end
