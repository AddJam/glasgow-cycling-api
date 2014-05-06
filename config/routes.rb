JourneyAPI::Application.routes.draw do
  # User
  post "/signup", to: "user#signup", as: 'signup'
  get "/signin", to: "user#signin", as: 'signin'
  post "/responses", to: "user#save_responses", as: 'responses'
  get "/details", to: "user#details", as: 'details'
  put "/details", to: "user#update_details", as: 'update_details'
  post "/forgot_password", to: "user#forgot_password", as: 'forgot_password'
  post "/reset_password", to: "user#reset_password", as: 'reset_password'

  # Reviews
  get "/reviews", to: "review#all", as: 'all_reviews'
  get "/reviews/:id", to: "review#find", as: 'find_review'
  post "/reviews", to: "review#create", as: 'create_review'
  delete "/reviews/:id", to: "review#delete", as: 'delete_review'
  put "/reviews/:id", to: "review#edit", as: 'edit_review'

  # Routes
  get '/routes/user_summaries/:per_page/:page_num', to: 'route#user_summaries', as: 'user_route_summaries'
  get '/routes/find/:id', to: "route#find", as: 'find_routes'
  post '/routes', to: 'route#record', as: 'record_route'
  get '/routes', to: 'route#search', as: 'search_routes'
  put '/routes/flag/:route_id', to: 'route#flag', as: 'flag_route'
  delete '/routes/:route_id', to: 'route#delete', as: 'delete_route'

  # Weather
  get '/weather/:per_page', to: 'weather#retrieve', as: 'retrieve'

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
