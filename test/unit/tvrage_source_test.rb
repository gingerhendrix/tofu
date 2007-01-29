require File.dirname(__FILE__) + '/../test_helper'


class TvrageSourceTest < Test::Unit::TestCase
  fixtures :sources, :tvrage_shows, :shows
  
  def setup
  end

  
  def test_find_show
  
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:quickinfo).with("Colbert").returns("http://localhost/eclipse/tofuMock/tvrage/quickinfo.php")
  
    show = TvrageSource.find_show "Colbert"
    
    assert_not_nil show
    assert_kind_of Hash, show
    assert_equal show, {'Show Name' => "The Colbert Report",
                        'Show URL' => "http://www.tvrage.com/The_Colbert_Report",
                        'Premiered' => "2005",
                        'Latest Episode' => {:number => '03x07',
                                             :name => 'Richard Clarke',
                                             :date => Date.new(2007, 1, 17)},
                        'Next Episode' => {:number => '03x08',
                                             :name => 'Bill O\'Reilly',
                                             :date => Date.new(2007, 1, 18)},
                        'Country' => 'USA',
                        'Status' => 'Returning Series',
                        'Classification' => 'Talk Shows',
                        'Genres' => 'Comedy',
                        'Network' => 'Comedy Central',
                        'Airtime' => 'Weekdays, 11:30 pm'}
                        
  end
  
  def test_parse_episodes
    
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/The_Colbert_Report").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/24.htm")
  
    source = TvrageSource.find 1
    info = source.parse_episodes
    
    assert_not_nil info
    
 #   assert_not_nil info[:seasons]
 #   assert_equal ["S-1", "S-2", "S-3", "S-4", "S-5", "S-6"],  info[:seasons]
    
    assert_not_nil info[:episodes]
    assert_equal 24, info[:episodes].length
    assert_equal info[:episodes][0], {:number => '121', :short_name => '6x01', :season_number => '6', :episode_number=> '01', :date => Date.civil(2007,01,14), :title => 'Day 6: 6:00 A.M.-7:00 A.M.', :url => 'http://www.tvrage.com/24/episodes/382670/06x01'}
    assert_equal info[:episodes][23], {:number => '144',  :short_name => '6x24', :season_number => '6', :episode_number=> '24',:date => Date.civil(2007,05,28), :title =>'Day 6: 5:00 A.M.-6:00 A.M.', :url => 'http://www.tvrage.com/24/episodes/485288/06x24' }
  end
  
   def test_parse_malformed_date
    
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/The_Colbert_Report").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/s6_dailyshow.htm")
  
    source = TvrageSource.find 1
    info = source.parse_episodes
    
    assert_not_nil info
    
 #   assert_not_nil info[:seasons]
 #   assert_equal ["S-1", "S-2", "S-3", "S-4", "S-5", "S-6"],  info[:seasons]
    
    assert_not_nil info[:episodes]
    assert_equal 10, info[:episodes].length
    assert_equal info[:episodes][0], {:number => '34', :short_name => '6x06', :season_number => '6', :episode_number=> '06', :date => nil, :title => 'Episode 34', :url => 'http://www.tvrage.com/The_Daily_Show/episodes/390663/06x06'}
    
  end
  
  def test_parse_specials
  mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/The_Colbert_Report").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/all_pokerafterdark.htm")
  
    source = TvrageSource.find 1
    info = source.parse_episodes
    
    assert_not_nil info
    
 #   assert_not_nil info[:seasons]
 #   assert_equal ["S-1", "S-2", "S-3", "S-4", "S-5", "S-6"],  info[:seasons]
    
    assert_not_nil info[:episodes]
    assert_equal 10, info[:episodes].length
  
  end
  
  
  def test_parse_episodes_single
#    @mock_tvrage.episode_list = "http://localhost/eclipse/tofuMock/tvrage/episode_list/all_brasseye.htm"
    
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/The_Colbert_Report").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/all_brasseye.htm")
  
    
    source = TvrageSource.find 1
    info = source.parse_episodes
    
    assert_not_nil info
    
 #   assert_not_nil info[:seasons]
 #   assert_equal ["S-1"],  info[:seasons]
    
    assert_not_nil info[:episodes]
    assert_equal 7, info[:episodes].length
    assert_equal info[:episodes][0], {:number => '1', :short_name => '1x01', :season_number => '1', :episode_number=> '01', :date => Date.civil(1997,01,29), :title => 'Animals', :url => 'http://www.tvrage.com/shows/id-556/episodes/261848/01x01'}
    assert_equal info[:episodes][6], {:number => '7',  :short_name => '1x07', :season_number => '1', :episode_number=> '07',:date => Date.civil(2001,07,26), :title =>'2001 Special (Paedophillia)', :url => 'http://www.tvrage.com/shows/id-556/episodes/261854/01x07' }
  end
  
  def test_parse_episodes_multiple
    
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/The_Colbert_Report").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/all_24.htm")
  
    
    source = TvrageSource.find 1
    info = source.parse_episodes
    
    assert_not_nil info
    
   # assert_not_nil info[:seasons]
   # assert_equal ["S-1", "S-2", "S-3", "S-4", "S-5", "S-6"],  info[:seasons]
    
    assert_not_nil info[:episodes]
    assert_equal  144, info[:episodes].length
    assert_equal info[:episodes][0], {:number => '1', :short_name => '1x01', :season_number => '1', :episode_number=> '01', :date => Date.civil(2001, 11, 06), :title => '12:00 A.M.-1:00 A.M.', :url => 'http://www.tvrage.com/24/episodes/590/01x01'}
    assert_equal info[:episodes][143], {:number => '144',  :short_name => '6x24', :season_number => '6', :episode_number=> '24',:date => Date.civil(2007, 05, 28), :title =>'Day 6: 5:00 A.M.-6:00 A.M.', :url => 'http://www.tvrage.com/24/episodes/485288/06x24' }
  end
  
  def test_create
    source = Source.find 1
    assert_not_nil source
    assert_kind_of TvrageSource, source
    assert_equal 3600, source.update_interval
    
    assert_equal shows(:colbert), source.show
    assert_not_nil tvrage_shows(:tvrage_colbert), source.tvrage_show
  end
  
  def test_update_episodes
    
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/shows/id-556").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/all_brasseye.htm")
  
    
    source = TvrageSource.find 2
         
    source.update_episodes
    
    assert_equal 7, source.show.episodes.count
    assert_equal 7, source.show.tvrage_episodes.count
    assert_equal 2, source.show.tvrage_episodes[0].show_id
    assert_equal source.show.tvrage_episodes.find(:first, :conditions => "episode_number = 1").title, "Animals" 
  end
end


