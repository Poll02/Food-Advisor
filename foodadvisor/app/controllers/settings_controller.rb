# app/controllers/settings_controller.rb
class SettingsController < ApplicationController
  before_action :authenticate_user! # Assicuriamoci che l'utente sia autenticato
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    @user.destroy
    reset_session # Resetta la sessione dopo aver eliminato l'utente
    redirect_to root_path, notice: 'Il tuo account è stato eliminato con successo.'       
  end

  private

  def set_user
    
    @user = current_user
  end

  def set_setting
    @setting = Setting.first_or_initialize
  end

  def setting_params
    params.require(:setting).permit(:font, :font_size, :theme)
  end

  def authenticate_user!
    redirect_to login_path, alert: "Devi effettuare il login per accedere a questa pagina." unless session[:user_id]
  end
end
