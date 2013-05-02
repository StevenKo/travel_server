require 'sidekiq/web'
TravelServer::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      
      resources :city_groups, :only => [:index]
      resources :nation_groups, :only => [:index]
      resources :nations, :only => [:index]
      resources :states, :only => [:index]
      resources :areas, :only => [:index]
      resources :area_intros
      resources :area_intro_cates
      resources :sites
      resources :notes

    end
  end
end
