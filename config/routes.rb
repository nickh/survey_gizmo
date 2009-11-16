ActionController::Routing::Routes.draw do |map|
  map.resources :responses do |responses|
    responses.resources :answers
  end
  map.root :controller => :responses
end
