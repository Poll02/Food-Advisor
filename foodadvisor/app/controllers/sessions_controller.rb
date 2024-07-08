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
        if utente.cliente && utente.cliente.user && utente.cliente.user.critico
          log_in(utente, 'Critico')  # Login come critico
        elsif utente.admin
          log_in(utente, 'Admin')  # Login come utente normale
        else
          log_in(utente, 'User')  # Login come utente normale
        end

        redirect_to root_path
      else
        flash[:alert] = 'Combinazione email/password non valida per l\'utente.'
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
      flash[:alert] = 'Combinazione P.IVA/password non valida per il ristoratore.'
      render 'new'  # Renderizza nuovamente il form di login per il ristoratore
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
