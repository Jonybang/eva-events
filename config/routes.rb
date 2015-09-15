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

  scope '/api', :defaults => {format: :json} do
    resources :organizations
    resources :forums
    resources :events
    resources :event_types
    resources :persons
    resources :rooms
    resources :colors
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
  mount RailsAdmin::Engine => '/adminpanel', :as => 'rails_admin'
  #root :to => redirect('/adminpanel')

  get 'manager' => 'manager#index'

  get '/:alias', to: 'forums#show'
  #get '*path' => 'application#index'
end
