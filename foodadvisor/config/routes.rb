Rails.application.routes.draw do
    get 'preferiti/show'

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
    
    # rotta per la pagina principale
    root 'home#index'
  
    # Defines the root path route ("/")
    # root "posts#index"
  
    get 'classifiche', to: 'classifiche#index'
    get 'supporto', to: 'supporto#index'
    resources :problems
    
    
    # grafico
    get 'bookings_per_week', to: 'info#bookings_per_week'
    get 'daily_bookings_and_events', to: 'info#daily_bookings_and_events'
  
    #
    # Rotta per il form di login (GET e POST)
    get 'login', to: 'sessions#new'
  
  
    get '/registration/user', to: 'registration#new_user', as: 'new_user_registration'
    post '/registration/user', to: 'registration#create_user', as: 'create_user_registration'
  
    get '/registration/critico', to: 'registration#new_critico', as: 'new_critico_registration'
    post '/registration/critico', to: 'registration#create_critico', as: 'create_critico_registration'
  
    get '/registration/ristoratore', to: 'registration#new_ristoratore', as: 'new_ristoratore_registration'
    post '/registration/ristoratore', to: 'registration#create_ristoratore', as: 'create_ristoratore_registration'
  
    delete '/settings/:id', to: 'settings#destroy'
    resources :registration, only: [:new, :new_user, :new_critico, :new_ristoratore, :create_user, :create_critico, :create_ristoratore]
    
  
    resources :sessions, only: [:new, :create, :destroy]
  
  
  
    # Rotte per le competizioni
    resources :competizione, only: [:index, :show] do
      member do
        post 'join', to: 'competizione#join_competition'
      end
    end
  
    #resources :prenotazioni, controller: 'prenotazione', only: [:create]
    resources :prenotazione do
        patch 'set_valida', on: :member  # Rotta per impostare la prenotazione come valida
    end
  
    #routes for profiles
    get 'critic_profile', to: 'critic_profile#show'
    get 'rest_profile', to: 'restaurateur_profiles#show'
    get 'admin_profile', to: 'admin_profile#show'
    get 'user_profile', to: 'user_profile#show'
  
    #rotta per il menu
    #get 'menu', to: 'menus#show'
    # piatti
    #resources :piattos, only: [:index, :show, :create, :destroy, :new]
  
    # Rotta per la pagina di registrazione
    get 'signup', to: 'registration#new'
    
    #route for placement
    get 'competizioni', to: 'competizione#index'
    
    # Rotte per le pagine della dashboard
    get 'dashboard', to: 'restaurateur_profiles#show'
    get 'info', to: 'info#show'
    get 'settings', to: 'settings#show'
  
    # rotte per le pagine vetrina
    get 'public_restaurant_profile/:id', to: 'restaurateur_profiles#public_show', as: 'public_restaurant_profile'
    get 'public_user_profile/:id', to: 'user_profile#public_show', as: 'public_user_profile'
    get 'public_critic_profile/:id', to: 'critic_profile#public_show', as: 'public_critic_profile'
  
    # per i tag
    post 'restaurateur_profiles/:tag_id/add_tag', to: 'restaurateur_profiles#add_tag', as: 'add_tag'
    post 'restaurateur_profiles/:tag_id/remove_tag', to: 'restaurateur_profiles#remove_tag', as: 'remove_tag'
    
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
    resources :competizioni, only: [:index]
    resource :restaurateur_profiles, only: [:show, :edit, :update] do
      post 'create_event', to: 'restaurateur_profiles#create_event'
      delete 'destroy_event/:id', to: 'restaurateur_profiles#destroy_event', as: 'destroy_event'
      post 'create_recipe', to: 'restaurateur_profiles#create_recipe'
      delete 'destroy_recipe/:id', to: 'restaurateur_profiles#destroy_recipe', as: 'destroy_recipe'
      post 'add_tag/:tag_id', to: 'restaurateur_profiles#add_tag'
      delete 'destroy_promotion/:id', to: 'restaurateur_profiles#destroy_promotion', as: 'destroy_promotion'
  
      post :create_promotion, on: :collection
  
      collection do
        patch 'update_info', to: 'restaurateur_profiles#update_info'
      end
    end
  
    resource :menus
    resources :piattos, only: [:new, :create, :destroy]
  
    resource :settings, only: [:show, :edit, :update, :destroy]
    resources :eventi, only: [:create]
    resources :info, only: [:show] 
  
    
    
    # Rotte aggiunte per creare e distruggere un dipendente
    post 'info/create_dipendente', to: 'info#create_dipendente', as: 'create_dipendente_info'
    delete 'info/destroy_dipendente/:id', to: 'info#destroy_dipendente', as: 'destroy_dipendente'
  
  
      #rotta per le recensioni
      resources :reviews, only: [:create]
      # rotta per visualizzare le recensioni pubbliche
      get '/public_show', to: 'reviews#public_show', as: 'public_show_reviews'
  
  
  end
