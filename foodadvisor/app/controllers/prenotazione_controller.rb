class PrenotazioneController < ApplicationController
  before_action :require_login

  def create
    @prenotazione = Prenotazione.new(prenotazione_params)
    @prenotazione.user_id = @current_user.cliente.user.id

    if @prenotazione.save
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def prenotazione_params
    params.require(:prenotazione).permit(:numero_persone, :data, :orario, :ristoratore_id)
  end

  def require_login
    unless logged_in?
      render json: { success: false, message: 'Devi essere loggato per effettuare una prenotazione' }
    end
  end
end
