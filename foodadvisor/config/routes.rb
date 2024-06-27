Rails.application.routes.draw do
  get 'user_profile/edit'
  get 'user_profile/show'
  get 'admin_profile/edit'
  get 'admin_profile/show'
  get 'profile/show'
  get 'critic_profile/show'
  get 'critic_profile/edit'
  get 'critic_profile/update'
  get 'competizione/index'
  get 'support/index'
  get 'menus/show'
  get 'menus/edit'
  get 'menus/update'
  # rotta per la pagina principale
  root 'home#index'

  # Defines the root path route ("/")
  # root "posts#index"

  get 'classifiche', to: 'classifiche#index'
  get 'supporto', to: 'supporto#index'
  resources :problems, only: [:create]


  #routes for profiles
  get 'critic_profile', to: 'critic_profile#show'
  get 'rest_profile', to: 'restaurateur_profiles#show'
  get 'admin_profile', to: 'admin_profile#show'
  get 'user_profile', to: 'user_profile#show'

  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'
  
  #route for placement
  get 'competizioni', to: 'competizione#index'
  
  # Rotte per le pagine della dashboard
  get 'dashboard', to: 'restaurateur_profiles#show'
  get 'info', to: 'info#show'
  get 'chat', to: 'chat#show'
  get 'settings', to: 'settings#show'

  # rotte per le pagine vetrina
  get 'public_restaurant_profile/:id', to: 'restaurateur_profiles#public_show', as: 'public_restaurant_profile'

  # per creare un evento
  post 'restaurateur_profiles/create_event', to: 'restaurateur_profiles#create_event', as: 'create_event_restaurateur_profiles'
  
  
  # rotte per il login
  # Rotta per il form di login (GET e POST)
  get 'login', to: 'sessions#new', as: :user_login
  post 'login', to: 'sessions#create_user'
  
  # Rotta per il form di login del ristoratore (GET e POST)
  get 'login_restaurateur', to: 'sessions#new', as: :restaurateur_login
  post 'login_restaurateur', to: 'sessions#create_restaurateur'
  
  # Rotta per il logout (DELETE)
  delete 'logout', to: 'sessions#destroy', as: :logout
  #get 'sessions/new'
  #get 'login', to: 'sessions#new'
  #post 'login', to: 'sessions#create'
  get 'auth/google_oauth2/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
    
  get 'home/index' 

  # rotte per la pagina di ricerca
  get 'ricerca', to: 'ricerca#index'
  get 'logout', to: 'sessions#destroy'

  get 'support', to: 'support#index'
  
  resources :promotions, only: [:index]
  resources :registrations, only: [:create]
  resources :competizioni, only: [:index]
  resource :restaurateur_profiles, only: [:show, :edit, :update] do
    post 'create_event', to: 'restaurateur_profiles#create_event'
    delete 'destroy_event/:id', to: 'restaurateur_profiles#destroy_event', as: 'destroy_event'
    delete 'destroy_promotion/:id', to: 'restaurateur_profiles#destroy_promotion', as: 'destroy_promotion'

    post :create_promotion, on: :collection

  end
  resource :settings, only: [:show, :edit, :update]
  resources :menus, only: [:show, :edit, :update, :new, :create]
  resources :eventi, only: [:create]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  direct :rails_blob_representation do |blob, options|
    route_for(:rails_disk_service, blob.key, options)
  end

  direct :rails_storage_proxy do |proxy, options|
    route_for(:rails_disk_service, proxy.key, options)
  end
end
