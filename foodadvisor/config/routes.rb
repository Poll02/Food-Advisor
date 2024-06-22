Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #route for critic_profile
  get 'critic_profile', to: 'profile#critic_profile'
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'

  # Rotta per creare una nuova registrazione
  resources :registrations, only: [:create]

  # Rotta per la pagina principale (opzionale)
  root 'welcome#index'
  get 'sessions/new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
