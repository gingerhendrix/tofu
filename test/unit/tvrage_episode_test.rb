require File.dirname(__FILE__) + '/../test_helper'

class TvrageEpisodeTest < Test::Unit::TestCase
  fixtures :tvrage_episodes, :episodes, :shows

  # Replace this with your real tests.
  def test_create
    episode = tvrage_episodes(:colbert_episode_one)
    assert_not_nil episode
    assert_equal episode.episode, episodes(:colbert_episode_one)
    assert_equal episode.show, shows(:colbert)
    
  end
end
