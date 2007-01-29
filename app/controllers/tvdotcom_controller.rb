class TvdotcomController < ApplicationController
  model :tvdotcom_episode
  include Tvdotcom
  
  def test
    colbert = Tvdotcom.new
    @episodes = colbert.episodes
  end
  
  def list
    @episodes  = TvdotcomEpisode.find :all
    render :action => "test"
  end
  
  def update 
      _update
     redirect_to(:action => "list")
  end
  
  def _update 
      colbert = Tvdotcom.new
      episodes = colbert.episodes
      episodes.each do |e| 
        uniqueEpisode = TvdotcomEpisode.count(["number = ?", e.number]);
        if uniqueEpisode==0 
          episode = TvdotcomEpisode.create e.to_hash
          episode.save
        end
      end
  end

end
