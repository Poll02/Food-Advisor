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
        if params[:session][:remember_me] == '1'
          remember(utente)
        end
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
    ristoratore = Ristoratore.find_by(piva: params[:restaurateur][:piva])
  
    if ristoratore && ristoratore.cliente && ristoratore.cliente.utente.authenticate(params[:restaurateur][:password])
      if params[:restaurateur][:remember_me] == '1'
        remember(ristoratore.cliente.utente)
      end
      log_in(ristoratore.cliente.utente, 'Ristoratore')  # Effettua il login con l'utente associato al ristoratore
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
  
    # Trova o crea l'utente nel database
    @user = Utente.find_by(email: profile['email']) 
      

      if @user.present?
        # Operazioni da eseguire se l'utente esiste già nel database
        # Salva l'utente nel database
        if @user.update({facebook_id: profile['id'], name: profile['name']})
            # Effettua il login dell'utente
    
            log_in(@user, 'User')  # Effettua il login con l'utente associato al ristoratore
            render json: { success: true, user: @user }
        else
            render json: { success: false, errors: @user.errors.full_messages }
        end

      else
        # Operazioni da eseguire se l'utente non esiste e deve essere creato
        # Genera una password sicura per il nuovo utente
        @user = Utente.new
        @user.build_cliente
        @user.cliente.build_user

        @user.email = profile['email']
        @user.password = generate_password
        @user.password_confirmation = @user.password
        @user.tmp_password = @user.password

        @user.telefono = nil
        @user.name = profile['name']
        @user.facebook_id = profile['id']

        @user.cliente.user.username = profile['name']
        profile['name'] = profile['name'].split(" ")
        @user.cliente.user.nome = profile['name'][0]
        @user.cliente.user.cognome = profile['last_name']
        @user.cliente.foto = profile.dig('picture', 'data', 'url') if profile.dig('picture', 'data', 'url').present?
        if @user.save
            log_in(@user, 'User')  # Effettua il login con l'utente associato al ristoratore
            render json: { success: true, user: @user}
        else
            render json: { success: false, errors: @user.errors.full_messages }
        end
      end

  end
  
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_google_login
    utente = Utente.from_omniauth(request.env['omniauth.auth'])
    log_in(utente, 'User') # Imposta il ruolo come 'User'
    redirect_to root_path
  end

  # Genera una password casuale di lunghezza 10 con almeno una lettera maiuscola
  def generate_password
    password = SecureRandom.hex(5)  # Genera una stringa esadecimale casuale di 10 caratteri (5 byte)
    unless password.match(/[A-Z]/)  # Verifica se la password contiene almeno una lettera maiuscola
      random_index = SecureRandom.random_number(password.length)
      password[random_index] = ('A'..'Z').to_a.sample  # Sostituisci un carattere casuale con una lettera maiuscola
    end
    password
  end

  def remember(utente)
    utente.remember
    cookies.permanent.signed[:user_id] = utente.id
    cookies.permanent[:remember_token] = utente.remember_token
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(utente)
    utente.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
