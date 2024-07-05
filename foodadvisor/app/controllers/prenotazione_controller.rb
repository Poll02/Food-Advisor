class PrenotazioneController < ApplicationController
  before_action :require_login
  before_action :set_prenotazione, only: [:set_valida, :destroy]

  def create
    @prenotazione = Prenotazione.new(prenotazione_params)
    @prenotazione.user_id = @current_user.cliente.user.id
    @prenotazione.valida = false  # Impostare valida a false

    if @prenotazione.save
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def set_valida
    @prenotazione.update(valida: true)
    render json: { success: true }
  end

  def destroy
    @prenotazione.destroy
    render json: { success: true }
  end

  private

  def set_prenotazione
    @prenotazione = Prenotazione.find(params[:id])
  end

  def prenotazione_params
    params.require(:prenotazione).permit(:numero_persone, :data, :orario, :ristoratore_id)
  end

  def require_login
    unless logged_in?
      render json: { success: false, message: 'Devi essere loggato per effettuare una prenotazione' }
    end
  end
end
