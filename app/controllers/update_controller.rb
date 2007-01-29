class UpdateController < ApplicationController

  def source
    @source = Source.find params[:source]
    @result = _update(source).result
  end

  def show
    @show = Show.find params[:id]
    @sources = @show.sources
    @results = Array.new
    @sources.each do |source|
      @results << _update(source).result
    end
  end
  
  def next
    next_update_time = Time.now
    next_source = false
    Source.find(:all).each do |s|
      if !s.next_update_time || s.next_update_time < next_update_time
        next_source = s
        next_update_time = s.next_update_time || Time.now  
      end 
    end
    if next_source
      @source = next_source
      @result = _update(next_source).result
    else
      #no update required
    end
  end
  
  def _update(source) 
    result = source.update
    Update.create :source => source, :time => DateTime.now, :result => result
  end
end
