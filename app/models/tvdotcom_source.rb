class TvdotcomSource < Source
 include Tvdotcom
 
 def update
    count = 0;
    logger.debug "Tvdotcom source updating"
    colbert = Tvdotcom.new
      episodes = colbert.episodes
      logger.debug "Found #{episodes.length}"
      all_episodes = TvdotcomEpisode.find :all
      episodes.each do |e| 
        uniqueEpisode = (all_episodes.select { |ep| "#{ep.number}" == "#{e.number}" }).length
        if uniqueEpisode==0
          logger.debug "Found new episode #{e.title}"
          episode = Episode.find_or_create :show_id => self[:show_id], :episode_date => e.air_date 
          tv_episode = TvdotcomEpisode.new e.to_hash
          tv_episode.episode = episode
          tv_episode.save
          count += 1; 
          logger.debug "episode #{count} saved"
         end
      end
    return count;
 end
 
end