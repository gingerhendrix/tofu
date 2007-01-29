class MockTvrage
  def quickinfo(name)
    "http://localhost/eclipse/tofuMock/tvrage/quickinfo.php"
  end
  
  def episode_list(url, season=nil)
    @episode_list
  end
  
  def episode_list=(url)
    @episode_list = url
  end
end