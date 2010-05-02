ActionController::Routing::Routes.draw do |map|

  map.resources :units, :member => { :current => :get }
  map.current_unit 'current_unit', :controller => 'units', :action => 'current'
  map.resources :words
  map.resources :exercises  
  map.resources :sentences
  map.resources :dialogs
  map.resources :assets, :has_many => :words, :has_many => :sentences

  map.root :controller => "units"
end
