
class ShowController < ApplicationController
  model :show
  layout "application", :except => [:rss]
 # helper :calendar

  def index
    @shows = Show.find :all
  
  end
  
  def new
  
  end
  
  def new2
    search = params[:search][:search]
    @result = TvrageSource.find_show CGI::escape(search)
      if !@result.nil?
        session[:search_result] = @result 
    end
  end
  

  def show
    @show = Show.find_by_short_name params[:name] #add includes
    @show_info =  Hash.new
    
    @latest_episode = @show.latest_episode
    if @latest_episode.nil?
      @show_info[:latest_episode] = nil
    else
      @show_info[:latest_episode] = @latest_episode.info;
    end
    
    @next_episode = @show.next_episode
    if @next_episode.nil?
      @show_info[:next_episode] = nil
    else
      @show_info[:next_episode] = @next_episode.info
    end
    
    @first_episode = @show.first_episode
    if @first_episode.nil?
      @show_info[:first_episode] = nil
    else
      @show_info[:first_episode] = @first_episode.info
    end
    
    @database_statistics = Hash.new
    @database_statistics[:number_of_episodes] = @show.episodes.count
    
    #Need to refactor database to allow this without iterating over all episodes
    #@database_statistics[:number_of_torrents] = Torrent.count :conditions => "show_id = #{@show.id}"
    
    recent_episodes = @show.recent_episodes 
    available = 0
    torrents = 0
    recent_episodes.each do |e|
      if !e.torrents.nil? &&  e.torrents.count > 0 
        available += 1
        torrents += e.torrents.count
      end
    end
        
    @database_statistics[:recent] = Hash.new
    @database_statistics[:recent][:torrents_per_episode] = ((1.0*torrents)/recent_episodes.length);
    @database_statistics[:recent][:availability] = ((1.0*available)/recent_episodes.length);
    
    @show_frequency = @show.frequency
    
    @feed = @show.feed
    
    
    
#    if !params[:start_week].nil? 
#      @start_week = Integer(params[:start_week])
#    else
#      @start_week = Integer((Time.now - @latest_episode.episode_date)/1.weeks)
#    end
    
    @episode_pages = Paginator.new self, @show.episodes.count, 10, params[:page]
    @episodes = @show.episodes.find :all, :order => 'episode_date DESC',
                          :limit  =>  @episode_pages.items_per_page,
                          :offset =>  @episode_pages.current.offset
    
    #@episode_pages, @episodes = paginate(@show.episodes, :order=>'episode_date DESC') 
        
    
    #make more regular by using show_frequency to smartly add date based limits 
    #@episodes = @show.episodes.find :all, :limit => 20, :order => "episode_date DESC"
    #@weeks_paginator = DatePaginator.new @episodes, :episode_date
  end

#  def rss
#    @torrents = Show.find_by_short_name(params[:name]).feed
#    render :action => 'rss', :layout => false
# end
# 
 def create
  if tvrage_show_info = session[:search_result]
    title = tvrage_show_info['Show Name']
    short_name = title.gsub(/\s/, '')
    
    show = Show.find_or_create :title => title,  :short_name => short_name
    
    tvrage_show = TvrageShow.new :show_name => title, :show_url => tvrage_show_info['Show URL']
    
    tvrage_show.show = show
    
    tvrage_source = TvrageSource.new :update_interval => 1.days 
    tvrage_source.tvrage_show = tvrage_show
    tvrage_source.show = show
    
    mininova_source = MininovaSource.new :update_interval => 12.hours
    mininova_source.show = show
    
    
    if show.valid? && tvrage_show.valid? && tvrage_source.valid? && mininova_source.valid?
      show.save
      tvrage_show.save
      tvrage_source.save
      mininova_source.save
      
      tvrage_source.init
      mininova_source.init
      # add sources 
      redirect_to :action => "show", :name => show.short_name
    else
      render :text => "Error - show cannot be created"
    end
  else
    render :text => "Error - this site will not work with cookies turned off"
  end
  
 end
 
# def sources
#  @show = Show.find_by_short_name params[:name] #add includes
#  @sources = @show.sources
# end
 
end
