
class MininovaSource < Source
 include ColbertTorrents
 
 def update
      _update;
 end
 
 def _update
      torrents = ColbertFinder.torrents
      count = 0;
      torrents.each do |t| 
        uniqueTorrent = Torrent.count(["url = ?", t.url]);
        if uniqueTorrent==0
          episode = Episode.find :first, :conditions => "show_id = #{self[:show_id]} AND TO_DAYS(episode_date) = TO_DAYS('#{t.episode}')"
          if !episode
             episode = Episode.create :show_id => self[:show_id], :episode_date => t.episode
          end  
          duplicateCount = episode.torrents.length
          torrent = Torrent.new t.to_hash
          torrent.episode = episode;
          if duplicateCount>0
             torrent.num = duplicateCount
          end
          torrent.save
          count += 1
        end
      end
      count
  end
end