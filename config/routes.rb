StudioSite::Application.routes.draw do
  get "calendar/index"

  get "master_data/show_styles"
  get "master_data/show_federations"
  get "master_data/show_term_groups"
  get "master_data/show_terms"
  get "master_data/copy_terms"
  
  resources :master_data

  get "sessions/new"
  #get "styles(/:id(.:format))"
  #match ':controller(/:action(/:id))(.:format)'
  
  #map.resources :styles
  match ':controller/:action/:id.:format'

  get "pages/home"
  get "pages/contact"
  get "pages/about"

  match '/signup',  :to => 'studios#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  
  resources :studios
  resources :sessions,    :only => [:new, :create, :destroy]
  resources :styles#,      :only => [:create, :destroy, :get]
  resources :term_groups#, :only => [:create, :destroy, :get]
  resources :terms#,       :only => [:create, :destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
