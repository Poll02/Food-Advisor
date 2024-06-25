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
  get 'ricerca', to: 'ricerca#index'
  get 'logout', to: 'sessions#destroy'

  get 'support', to: 'support#index'
  #
  resources :registrations, only: [:create]
  resources :competizioni, only: [:index]
  resource :restaurateur_profile, only: [:show, :edit, :update]
  resource :settings, only: [:show, :edit, :update]
  resource :menus, only: [:show, :edit, :update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
