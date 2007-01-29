require File.dirname(__FILE__) + '/../test_helper'

require 'show_controller'

require 'mocha'

#require File.dirname(__FILE__) + '/../doubles/MockTvrage'

# Re-raise errors caught by the controller.
class ShowController; def rescue_action(e) raise e end; end

class ShowControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    
    #@mock_tvrage = MockTvrage.new
    #TvrageSource.tvrage = @mock_tvrage 
  end

  # TODO: Replace with test data not already partially found in Fixtures
  def test_create
    mock_tvrage = mock()
    TvrageSource.tvrage = mock_tvrage 
    mock_tvrage.expects(:quickinfo).with("24").returns("http://localhost/eclipse/tofuMock/tvrage/quickinfo/24.html")
    mock_tvrage.expects(:episode_list).with("http://www.tvrage.com/24").returns("http://localhost/eclipse/tofuMock/tvrage/episode_list/all_24.htm")
    
  #  assert_nil TvrageShow.find_by_show_name("24")
    
    @request.session[:search_result] = TvrageSource.find_show "24"
    
    post :create
    
    assert_redirected_to :controller=> 'show', :action => 'show', :name => "24"
    
    
    assert_not_nil tvrage_show = TvrageShow.find_by_show_name("24")
    assert_equal "24", tvrage_show.show_name
    assert_equal "http://www.tvrage.com/24", tvrage_show.show_url
    assert_not_nil show = tvrage_show.show
    assert_equal "24", show.title
    assert_equal "24", show.short_name
    assert_not_nil show.episodes
    assert_equal 144, tvrage_show.show.episodes.count
    assert_equal 144, tvrage_show.show.tvrage_episodes.count
    
  end
end
