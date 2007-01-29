require File.dirname(__FILE__) + '/../test_helper'

class TvrageShowTest < Test::Unit::TestCase
  fixtures :tvrage_shows, :sources
  
  # Replace this with your real tests.
  def test_create
    show = TvrageShow.find 1
    assert_not_nil show
    assert_equal "The Colbert Report", show.show_name
    assert_equal "http://www.tvrage.com/The_Colbert_Report", show.show_url
    assert_not_nil show.source
    assert_equal sources(:tvrage_colbert), show.source
  end
end
