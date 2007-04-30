require File.dirname(__FILE__) + '/../test_helper'


class MininovaSourceTest < Test::Unit::TestCase
  fixtures :sources, :tvrage_shows, :shows, :episodes
  
  def test_parse_torrents
    mock_server = mock()
    MininovaSource.server = mock_server
    
    mock_server.expects(:search).with("The Colbert Report").returns("http://localhost/eclipse/tofuMock/mininova/search/the_colbert_report.html")
    
    source = sources(:mininova_colbert)
    
    torrents = source.parse_torrents
    
    assert_not_nil torrents
    assert_kind_of Array, torrents
    assert_equal torrents.length, 125
    
    assert_equal torrents[0], {:date_added => "20 Apr 07", 
                               :title => "The colbert report 04-19-07 dsr xvid-crimson",
                               :url => "http://www.mininova.org/get/668197"}     
    assert_equal torrents[124], {:date_added => "17 Aug 06", 
                               :title => "The Colbert Report 16th of August 2006",
                               :url => "http://www.mininova.org/get/399127"}                               
    
  end
  
  def test_update
    mock_server = mock()
    MininovaSource.server = mock_server
    
    mock_server.expects(:search).with("The Colbert Report").returns("http://localhost/eclipse/tofuMock/mininova/search/the_colbert_report.html")
    
    source = sources(:mininova_colbert)
    
    episode = episodes(:colbert_19_april_2007)
    episode.torrents.each {|t| t.destroy}
    episode.reload
    torrents = episode.torrents
    assert_equal [], torrents
    source.update

    episode.reload
    torrents = episode.torrents
    
    assert_equal 1, torrents.length
    assert_equal torrents[0].url, "http://www.mininova.org/get/668197"
    assert_equal torrents[0].title, "The colbert report 04-19-07 dsr xvid-crimson"
    assert_equal torrents[0].num, 0
    
  end
  
  def test_extract_date
    source = sources(:mininova_colbert)
    
    date = source._extract_date "The colbert report 04-19-07 dsr xvid-crimson"
    assert_not_nil date
    assert_equal date, DateTime.civil(2007,4,19, 0, 0, 0)
        
  end
  
  def test_extract_episode
    test = [];
    test[0] = {:title => "South Park S11E06 [ipodnova tv] mp4 [www iPodNova tv]", :season => 11, :episode =>6}
    test[1] = {:title => "South Park - S11 E6", :season => 11, :episode =>6}
    test[2] = {:title => "South.Park.S11E06.DSR.XviD-NoTV [www.dabug.org]", :season => 11, :episode =>6}
    test[3] = {:title => "South Park 11x06 (DSRip-NOTV) [VTV]", :season => 11, :episode =>6}
    
    source = sources(:mininova_colbert)
    test.each do |t|
      (season, episode) = source._extract_episode t[:title]
      assert_equal t[:season], season, "#{t[:title]}"
      assert_equal  t[:episode], episode, "#{t[:title]}"
    end
  end
end