Rails.application.routes.draw do
  get 'menus/show'
  get 'menus/edit'
  get 'menus/update'
  # rotta per la pagina principale
  root 'home#index'

  # Defines the root path route ("/")
  # root "posts#index"

  #route for critic_profile
  get 'critic_profile', to: 'profile#critic_profile'
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'
  get 'rest_profile', to: 'restaurateur_profiles#show'
  #route for placement
  get 'classifiche', to: 'classifica#classifica'
  # Rotte per le pagine della dashboard
  get 'dashboard', to: 'restaurateur_profiles#show'
  get 'info', to: 'info#show'
  get 'chat', to: 'chat#show'
  get 'settings', to: 'settings#show'
  #
  get 'sessions/new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
    
  get 'home/index' 
  get 'ricerca', to: 'ricerca#index'
  delete 'logout', to: 'sessions#destroy'

  #
  resources :registrations, only: [:create]
  resource :restaurateur_profiles, only: [:show, :edit, :update]
  resource :settings, only: [:show, :edit, :update]
  resource :menus, only: [:show, :edit, :update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
