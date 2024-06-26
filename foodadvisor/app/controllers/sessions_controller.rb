# app/controllers/sessions_controller.rb
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
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in(user, 'User')  # Metodo per effettuare il login definito altrove
        redirect_to root_path
      else
        flash.now[:alert] = 'Combinazione email/password non valida per l\'utente.'
        render 'new'  # Renderizza nuovamente il form di login per l'utente
      end
    end
  end

  def create_restaurateur
    restaurateur = Ristoratori.find_by(piva: params[:restaurateur][:piva])
    if restaurateur && restaurateur.authenticate(params[:restaurateur][:password])
      log_in(restaurateur, 'Ristoratore')  # Metodo per effettuare il login per il ristoratore
      redirect_to root_path
    else
      flash.now[:alert] = 'Combinazione P.IVA/password non valida per il ristoratore.'
      render 'new'  # Renderizza nuovamente il form di login per il ristoratore
    end
  end
  

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def handle_google_login
    user = User.from_omniauth(request.env['omniauth.auth'])
    log_in(user, 'User') # Imposta il ruolo come 'User'
    redirect_to root_path
  end

end
