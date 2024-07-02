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
