class SettingsController < ApplicationController
  before_action :authenticate_user! # Assicuriamoci che l'utente sia autenticato
  before_action :set_user
  before_action :set_setting  

  layout 'with_sidebar'

  def show
  end

  def edit
  end

  def update
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Impostazioni aggiornate con successo.'
    else
      render :edit
    end
  end

  def update_credentials
    @current_user = current_user
  
    # Aggiornamento delle credenziali di base
    if @current_user.cliente
      if @current_user.cliente.ristoratore
        if params[:utente][:piva].present?
          @current_user.cliente.ristoratore.update(piva: params[:utente][:piva])
        end
      end
      @current_user.update(email: params[:utente][:email])
    end
  
    # Verifica della password corrente e aggiornamento della nuova password
    if params[:utente][:password].present?
      if @current_user.authenticate(params[:current_password])
        # Se la password corrente è corretta, aggiorna la password
        if @current_user.update(user_params)
          flash[:notice] = 'Credenziali aggiornate con successo.'
          redirect_to settings_path
        else
          flash[:alert] = 'Errore nell\'aggiornamento delle credenziali.'
          render :edit
        end
      else
        flash[:alert] = 'Password corrente non corretta.'
        redirect_to edit_settings_path
      end
    else
      # Se non è fornita una nuova password, non aggiornare la password
      flash[:notice] = 'Credenziali aggiornate con successo.'
      redirect_to settings_path
    end
  end
  

  def destroy
    begin
      @user.destroy

      session[:utente_id] = nil  # Assicurati di eliminare anche la sessione

      redirect_to root_path, notice: "Account cancellato con successo."
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Utente non trovato."
    end
  end

  private

  def user_params
    if session[:role] == 'Ristoratore'
      params.require(:utente).permit(:email, :password, :password_confirmation, cliente_attributes: [:id, ristoratore_attributes: [:id, :piva]])
    else
      params.require(:utente).permit(:email, :password, :password_confirmation)
    end
  end

  def set_user
    @user = current_user
  end

  def set_setting
    @setting = Setting.find_by(utente_id: @user.id)
  end

  def setting_params
    params.require(:setting).permit(:font, :font_size, :theme)
  end

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Devi effettuare il login per accedere a questa pagina."
    end
  end

  def current_user
    @current_user ||= Utente.find(session[:user_id]) if session[:user_id]
  end
end
