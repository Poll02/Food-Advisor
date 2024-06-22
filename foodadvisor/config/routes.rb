Rails.application.routes.draw do
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'
  get 'profile', to: 'restaurateur_profiles#show'

  # Rotta per creare una nuova registrazione
  resources :registrations, only: [:create]
  resource :restaurateur_profiles, only: [:show, :edit, :update]

  # Rotta per la pagina principale (opzionale)
  root 'welcome#index'

  # Rotte per le pagine della dashboard
  get 'dashboard', to: 'dashboard#show'
  get 'info', to: 'info#show'
  get 'menu', to: 'menu#show'
  get 'chat', to: 'chat#show'
  get 'settings', to: 'settings#show'
end
