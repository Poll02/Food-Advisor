Rails.application.routes.draw do
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'

  # Rotta per creare una nuova registrazione
  resources :registrations, only: [:create]
  resource :restaurateur_profile, only: [:show, :edit, :update]

  # Rotta per la pagina principale (opzionale)
  # root 'welcome#index'

  # rotte per la dashboard
  root 'dashboard#show' # Imposta la pagina di default

  # Rotte per le pagine della dashboard
  get 'dashboard', to: 'dashboard#show'
  get 'info', to: 'info#show'
  get 'menu', to: 'menu#show'
  get 'chat', to: 'chat#show'
  get 'settings', to: 'settings#show'
end
