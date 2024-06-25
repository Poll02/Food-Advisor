# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end
  end

  def create
    if request.env['omniauth.auth'] # Login tramite Google
      handle_google_login
    else # Login normale
      if params[:user]
        handle_user_login
      elsif params[:restaurateur]
        handle_restaurateur_login
      else
        flash.now[:alert] = 'Tipo di login non valido.'
        render 'new'
      end
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

  def handle_user_login
    user = User.find_by(email: params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      log_in(user, 'User') # Imposta il ruolo come 'User'
      redirect_to root_path
    else
      flash.now[:alert] = 'Combinazione email/password non valida per l\'utente.'
      render 'new'
    end
  end
  
  def handle_restaurateur_login
    restaurateur = Ristoratori.find_by(piva: params[:restaurateur][:piva])
    if restaurateur && restaurateur.authenticate(params[:restaurateur][:password])
      log_in(restaurateur, 'Ristoratore') # Imposta il ruolo come 'Ristoratore'
      redirect_to root_path
    else
      flash.now[:alert] = 'Combinazione P.IVA/password non valida per il ristoratore.'
      render 'new'
    end
  end
end
