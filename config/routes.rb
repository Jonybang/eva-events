
Rails.application.routes.draw do
  root :to => 'application#index'

  get 'logout' => 'sessions#destroy', :as => 'log_out'

  get 'login' => 'sessions#new', :as => 'log_in'
  post 'login' => 'sessions#create'

  get 'register' => 'users#new', :as => 'sign_up'
  post 'register' => 'users#create'

  get 'user_id' => 'application#user_id'
  get 'current_person' => 'application#current_person', :defaults => {format: :json}

  resources :users, :except => :new
  resources :sessions, :except => :new
  resources :issues

  get 'api' => 'api#index'

  scope :api, :defaults => {format: :json} do
    resources :organizations
    resources :forums do
      scope :module => :forum do
        resources :persons do
          resources :likes
          delete 'likes' => 'likes#destroy'

          get 'subscribed_events' => 'persons#subscribed_events'
        end
        resources :events do
          resources :likes
          delete 'likes' => 'likes#destroy'

          post 'subscribes' => 'events#person_subscribe'
          get 'subscribes' => 'events#subscribes'
          delete 'subscribes' => 'events#person_unsubscribe'
        end
        resources :news do
          resources :likes
          delete 'likes' => 'likes#destroy'
        end
        resources :rooms do
          resources :likes
          delete 'likes' => 'likes#destroy'
        end
        resources :telegram_users
      end
    end
    resources :events
    resources :event_types
    resources :persons
    resources :rooms
    resources :colors
    resources :news
    resources :tasks
    resources :likes

    post 'login' => 'sessions#api_create'
    get 'current_user_id' => 'sessions#current_user_id'
    post 'logout' => 'sessions#api_destroy'
    post 'anonym_register' => 'users#api_anonym_create'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  constraints lambda {|request| AuthConstraint.admin?(request) } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/adminpanel', :as => 'rails_admin'

  get 'qr' => 'qr#index'
  get 'support' => 'issues#new'

  get 'manager' => 'manager#index'

  post '158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw' => 'telegram_users#command_execute'
  post '/' => 'telegram_users#root_post'

  get '/manager/*path' => 'manager#index'

  get '/:alias', to: 'forums#show'
  #get '/:forum_alias/:event_alias', to: 'events#show'
  get '/:forum_alias/:room_alias', to: 'rooms#show'
  get '/:forum_alias/:room_alias/:event_alias', to: 'events#show'
  #get '*path' => 'application#index'
end
