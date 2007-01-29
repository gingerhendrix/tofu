class SearchController < ApplicationController
  layout "application"
  
  def index
  
  
  end

  def search
      search = params[:search][:search]
      @result = TvrageSource.find_show CGI::escape(search)
      if !@result.nil?
        session[:search_result] = @result 
      end
  end

end
