ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '', :controller => 'show', :action => 'index'

  map.connect 'show/', :controller => 'show', :action => 'index'

  map.connect 'create', :controller => 'show', :action => 'create'
  
  map.connect 'rss', :controller => 'show', :action => 'rss'
  
  map.connect 'new', :controller => 'show', :action => 'new'
  
  map.connect 'new2', :controller => 'show', :action => 'new2'

  map.connect 'show/:name/', :controller => 'show', :action => 'show'
  
  map.connect 'show/:name/:action', :controller=> 'show'
  
  
  map.connect 'update/show/:id', :controller=> 'update', :action => 'show'

  # Install the default route as the lowest priority.  
  map.connect ':controller/:action'
end
