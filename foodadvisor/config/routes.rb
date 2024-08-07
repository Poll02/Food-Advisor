Rails.application.routes.draw do
    
    get 'user_notifications/index'
    get 'preferiti/show'
    get 'user_profile/edit'
    get 'user_profile/show'
    put 'user_profile/update'
    get 'admin_profile/edit'
    get 'admin_profile/show'
    get 'profile/show'
    get 'critic_profile/show'
    get 'critic_profile/edit'
    put 'critic_profile/update'
    get 'competizione/index'
    get 'support/index'
    
    # rotta per la pagina principale
    root 'home#index'
    get 'root', to: 'home#index' 

    #caalback fb
    post 'auth/facebook/callback', to: 'sessions#facebook'
  
    # Defines the root path route ("/")
    # root "posts#index"

    # config/routes.rb
  resources :favorites, only: [] do
    delete :remove_rest_from_favorites, on: :collection
  end

  # config/routes.rb
  resources :favorites, only: [] do
    delete :remove_recipe_from_favorites, on: :collection
  end


  
    get 'classifiche', to: 'classifiche#index'
    get 'supporto', to: 'supporto#index'

    get 'about', to: 'about#index'

    
    resources :problems do
      member do
        put 'aggiorna_stato_problema', to: 'problems#aggiorna_stato_problema'
      end
    end

    resources :notifications, only: [:new, :create]
    resources :user_notifications, only: [:index]

    post 'restaurateur_profiles/update_pin', to: 'restaurateur_profiles#update_pin', as: 'update_pin_restaurateur_profile'
    
    # grafico
    get 'bookings_per_week', to: 'info#bookings_per_week'
    get 'daily_bookings_and_events', to: 'info#daily_bookings_and_events'

    # grafici personali
    get 'daily_bookings', to: 'critic_profile#daily_bookings'
    get 'monthly_bookings', to: 'critic_profile#monthly_bookings'
    get 'daily_bookings_user', to: 'user_profile#daily_bookings_user'
    get 'monthly_bookings_user', to: 'user_profile#monthly_bookings_user'
  
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
    resources :competizione, only: [:index, :create] do
      member do
        get 'assegna_punti', to: 'competizione#assegna_punti'
        post 'join', to: 'competizione#join_competition'
        delete 'delete_competizione', to: 'competizione#destroy'
        delete 'elimina_partecipante', to: 'competizione#elimina_partecipante'
      end
    end
    post '/competizione/create', to: 'competizione#create', as: 'create_competizione'
  
    #resources :prenotazioni, controller: 'prenotazione', only: [:create]
    resources :prenotazione do
        patch 'set_valida', on: :member  # Rotta per impostare la prenotazione come valida
    end
  
    #routes for profiles
    get 'critic_profile', to: 'critic_profile#show'
    get 'rest_profile', to: 'restaurateur_profiles#show'
    get 'admin_profile', to: 'admin_profile#show'
    delete 'admin_profile_user_delete', to: 'admin_profile#destroy'
    get 'user_profile', to: 'user_profile#show'
  
    #rotta per il menu
    #get 'menu', to: 'menus#show'
    # piatti
    #resources :piattos, only: [:index, :show, :create, :destroy, :new]
  
    # Rotta per la pagina di registrazione
    get 'signup', to: 'registration#new'

    post 'add_rest_to_favorites', to: 'favorites#add_rest_to_favorites'
    post 'add_event_to_favorites', to: 'favorites#add_event_to_favorites'
    post 'add_recipe_to_favorites', to: 'favorites#add_recipe_to_favorites'



    
    #route for placement
    get 'competizioni', to: 'competizione#index'
    get 'competizione_create', to: 'competizione#create'
    
    # Rotte per le pagine della dashboard
    get 'dashboard', to: 'restaurateur_profiles#show'
    get 'info', to: 'info#show'
    get 'settings', to: 'settings#show'
  
    # rotte per le pagine vetrina
    get 'public_restaurant_profile/:id', to: 'restaurateur_profiles#public_show', as: 'public_restaurant_profile'
    get 'public_user_profile/:id', to: 'user_profile#public_show', as: 'public_user_profile'
    get 'public_critic_profile/:id', to: 'critic_profile#public_show', as: 'public_critic_profile'
    get 'public_show_menus/:id', to: 'menus#public_show', as: 'public_show_menus'
  
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
      
    get 'home/index'
    
  
    # rotte per la pagina di ricerca
    get 'ricerca', to: 'ricerca#index'
    get 'logout', to: 'sessions#destroy'
    get 'ricerca/:id/map_info', to: 'ricerca#map_info'

  
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
  
    resource :user_profile, only: [:show, :edit, :update] do
      put 'update', on: :member
    end

    resource :critic_profile, only: [:show, :edit, :update] do
      put 'update', on: :member
    end

    resource :menus
    resources :piattos, only: [:new, :create, :destroy]
  
    resource :settings, only: [:show, :edit, :update, :destroy]
    put 'update_credentials', to: 'settings#update_credentials'
    post 'verify_password', to: 'settings#verify_password'
    resources :eventi, only: [:create]
    resources :info, only: [:show] 
  
    resource :segnalaziones, only: [:create]
    get 'segnalazione_index', to: 'segnalaziones#index'
    delete 'segnalzaione_delete', to: 'segnalaziones#destroy'

    
    # Rotte aggiunte per creare e distruggere un dipendente
    post 'info/create_dipendente', to: 'info#create_dipendente', as: 'create_dipendente'
    delete 'info/destroy_dipendente/:id', to: 'info#destroy_dipendente', as: 'destroy_dipendente'

    #rotte per le risposte dei ristoratori
    post 'answer_create', to: 'answer#create'
    post 'answer_update', to: 'answer#update'
    delete 'answer_delete', to: 'answer#destroy'
  
    post 'update_review', to: 'reviews#update'
    #rotta per le recensioni
    resources :reviews, only: [:create, :destroy] do
      member do
        post 'add_like'
      end
    end

    # AUTHENTICATION ROUTES 
    get 'auth/:provider/callback', to: 'sessions#create' 
    get '/sign_out', to: 'sessions#destroy', as: :sign_out 
    get '/auth/google_oauth2', as: :sign_in
    get '/auth/failure' => 'sessions#failure'
  end
