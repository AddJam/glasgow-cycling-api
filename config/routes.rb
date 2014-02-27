JourneyAPI::Application.routes.draw do
  # User
  post "/signup", to: "user#signup", as: 'signup'
  get "/signin", to: "user#signin", as: 'signin'
  post "/responses", to: "user#save_responses", as: 'responses'
  get "/details/", to: "user#details", as: 'details'

  # Reviews
  get "/reviews", to: "review#all", as: 'all_reviews'
  get "/reviews/:id", to: "review#find", as: 'find_review'
  post "/reviews", to: "review#create", as: 'create_review'
  delete "/reviews/:id", to: "review#delete", as: 'delete_review'
  put "/reviews/:id", to: "review#edit", as: 'edit_review'

  # Routes
  get "/routes/summaries/:per_page/:page_num", to: "route#all_summaries", as: 'all_summaries'
  get "/routes/user_summaries/:per_page/:page_num", to: "route#user_summaries", as: 'user_route_summaries'
  get "/routes/:id", to: "route#find", as: 'find_routes'
  post "/routes", to: "route#record", as: 'record_route'
  get "/routes/nearby", to: "route#nearby_summaries", as: 'nearby_routes'
  get "/routes/user", to: "route#user", as: 'user_routes'

  devise_for :users
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
end
