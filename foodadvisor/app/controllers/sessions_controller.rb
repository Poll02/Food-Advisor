class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end
  end

  def create_user
    if request.env['omniauth.auth'] # Login tramite Google
      handle_google_login
    else # Login normale
      utente = Utente.find_by(email: params[:session][:email].downcase)

      if utente && utente.authenticate(params[:session][:password]) 
        if utente.admin
          log_in(utente, 'Admin')  # Login come utente normale
          redirect_to root_path
        elsif utente.cliente.user
          if utente.cliente.user.critico
            log_in(utente, 'Critico')  # Login come critico
          else 
            log_in(utente, 'User')  # Login come utente normale
          end
          redirect_to root_path
        end
      else
        flash.now[:alert] = 'Combinazione email/password non valida per l\'utente.'
        render 'new'  # Renderizza nuovamente il form di login per l'utente
      end
    end
  end

  def create_restaurateur
    restauratore = Ristoratore.find_by(piva: params[:restaurateur][:piva])

    if restauratore && restauratore.cliente && restauratore.cliente.utente.authenticate(params[:restaurateur][:password])
      log_in(restauratore.cliente.utente, 'Ristoratore')  # Effettua il login con l'utente associato al ristoratore
      redirect_to root_path
    else
      flash.now[:alert] = 'Combinazione P.IVA/password non valida per il ristoratore.'
      render 'new'  # Renderizza nuovamente il form di login per il ristoratore
    end
  end

  def facebook
    access_token = params[:access_token]
    @graph = Koala::Facebook::API.new(access_token)
    
    # Definisci i campi che desideri ottenere da Facebook
    fields = 'id,name,email,first_name,last_name,picture.type(large)'
    profile = @graph.get_object('me', fields: fields)
  
    Rails.logger.info("Inizio ricerca utente nel database")
    Rails.logger.info("dati profilo da facebook #{profile}")

    # Trova o crea l'utente nel database
    @user = Utente.find_by(email: profile['email']) 
      Rails.logger.info("dati utente #{@user.inspect}")
      

      if @user.present?
        Rails.logger.info("Utente trovato nel database")
        # Operazioni da eseguire se l'utente esiste già nel database
        Rails.logger.info("dati utente user completi #{@user.cliente.user.inspect}")

      else
        Rails.logger.info("Utente non trovato nel database, quindi ne creo uno nuovo")
        # Operazioni da eseguire se l'utente non esiste e deve essere creato
        # Genera una password sicura per il nuovo utente
        @user = Utente.new
        @user.build_cliente
        @user.cliente.build_user
        Rails.logger.info("utente buildato")

        @user.password = SecureRandom.hex(10)
        @user.password_confirmation = @user.password

        @user.name = profile['name']
        @user.facebook_id = profile['id']

        @user.cliente.user.nome = profile['name']
        @user.cliente.user.username = profile['name']
        @user.cliente.user.cognome = profile['last_name']
        @user.cliente.foto = profile.dig('picture', 'data', 'url') if profile.dig('picture', 'data', 'url').present?
      end

      
    

      Rails.logger.info("campo nome da aggiungere #{profile['id']}")
      Rails.logger.info("campo nome da agg #{profile['name']}")

  
    # Salva l'utente nel database
    if @user.update({facebook_id: profile['id'], name: profile['name']})
      Rails.logger.info("Utente aggiornato con successo nel database")
      # Effettua il login dell'utente
      
      log_in(@user, 'User')  # Effettua il login con l'utente associato al ristoratore
      render json: { success: true, user: @user }
    else
      Rails.logger.info("aggiornamento non effettuato")
      Rails.logger.info("Errori di validazione: #{@user.errors.full_messages}")
      render json: { success: false, errors: @user.errors.full_messages }
    end
  end
  
  
  
  def destroy
    log_out
    redirect_to root_url
  end

  private

  def handle_google_login
    utente = Utente.from_omniauth(request.env['omniauth.auth'])
    log_in(utente, 'User') # Imposta il ruolo come 'User'
    redirect_to root_path
  end

end
