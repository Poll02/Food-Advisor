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
end
