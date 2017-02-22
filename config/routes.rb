Rails.application.routes.draw do
  root 'user#login_window'
  
  post 'login' => 'user#login'
  get 'logout' => 'user#destroy'
  match 'forgot_password' => 'user#forgot_password' , :via => [:get, :post]
  match 'change_password' => 'user#change_password' , :via => [:get, :post]
  get 'check_password' => 'user#check_password' 
  
  get 'user/index' => 'user#index'
  match 'user/edit/:user_id' => 'user#edit', :via => [:get, :post]
  get 'user/delete/:user_id' => 'user#delete'
  get 'validate_username_old' => 'user#validate_username_old'

  get 'home/index' => 'home#index'
  get 'home/show/:home_id' => 'home#show'
  match 'home/edit/:home_id' => 'home#edit', :via => [:get, :post]
  get 'home/delete/:home_id' => 'home#delete'
  post '/home_image/add/:home_id/' => 'home#home_image_add'
  get '/home_image/delete/:image_id' => 'home#home_image_delete'

  post 'api_login' => 'api#login'
  post 'api_logout' => 'api#logout'
  post 'api_add_home' => 'api#add_home'
  post 'api_filter' => 'api#filter'
  post 'api_home_data' => 'api#home_data'
  post 'api_guest_signup' => 'api#guest_signup'
  post 'api_update_device_token' => 'api#update_device_token'
  post 'api_show_user' => 'api#show_user'
  post 'api_edit_user' => 'api#edit_user'
  post 'api_send_message' => 'api#send_message'
  post 'api_fetch_message' => 'api#fetch_message'
  post 'api_fetch_user_chat' => 'api#fetch_user_chat'
  post 'api_fetch_after_date' => 'api#fetch_after_date'
  post 'api_user_homes' => 'api#user_homes'
  post 'api_edit_home' => 'api#edit_home'
  post 'api_delete_home' => 'api#delete_home'
  post 'api_delete_image' => 'api#delete_image'
  post 'api_add_image' => 'api#add_image'
  post 'api_email_validate' => 'api#email_validate'
  post 'api_delete_chat' => 'api#delete_chat'
  
  post 'notification_test' => 'api#notification_test'
  
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
