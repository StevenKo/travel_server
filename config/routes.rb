require 'sidekiq/web'
TravelServer::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      
      resources :city_groups, :only => [:index]
      resources :nation_groups, :only => [:index]
      resources :nations, :only => [:index]
      resources :states, :only => [:index]
      
      resources :areas, :only => [:index] do
        collection do 
          get 'group_areas'
        end
      end
      
      resources :area_intros
      resources :area_intro_cates
      
      resources :sites do
        collection do 
          get 'nation_group'
        end
      end
      
      resources :notes do
        collection do 
          get 'nation_group'
          get 'most_view_notes'
          get 'new_notes'
          get 'best_notes'
        end
      end

    end
  end
end
