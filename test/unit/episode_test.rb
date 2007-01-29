require File.dirname(__FILE__) + '/../test_helper'

class EpisodeTest < Test::Unit::TestCase
  fixtures :episodes, :shows

  # Replace this with your real tests.
  def test_fixture
    episode = episodes(:colbert_episode_one)
    assert_not_nil episode
    assert_equal episode.show, shows(:colbert)
  end
  

  
end
