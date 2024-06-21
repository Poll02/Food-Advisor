Rails.application.routes.draw do
  # Rotta per la pagina di registrazione
  get 'signup', to: 'registrations#new'

  # Rotta per creare una nuova registrazione
  resources :registrations, only: [:create]

  # Rotta per la pagina principale (opzionale)
  root 'welcome#index'
end
