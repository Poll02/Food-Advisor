Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #route for critic_profile
  get 'critic_profile', to: 'profile#critic_profile'
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'
  get 'rest_profile', to: 'restaurateur_profiles#show'

  # Rotta per creare una nuova registrazione
  resources :registrations, only: [:create]
  resource :restaurateur_profile, only: [:show, :edit, :update]

  # Rotta per la pagina principale (opzionale)
  get 'sessions/new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  root 'home#index'  
  get 'home/index' 
  get 'ricerca', to: 'ricerca#index'
  delete 'logout', to: 'sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # Rotte per le pagine della dashboard
  get 'dashboard', to: 'dashboard#show'
  get 'info', to: 'info#show'
  get 'menu', to: 'menu#show'
  get 'chat', to: 'chat#show'
  get 'settings', to: 'settings#show'
end
