class PrenotazioneController < ApplicationController
  before_action :require_login
  before_action :set_prenotazione, only: [:set_valida, :destroy]

  def create
    if session[:role] != 'User'
      render json: { success: false, error: 'Devi essere loggato come utente per prenotare' }, status: :unauthorized
      return
    end
    Rails.logger.info("Inizio creazione prenotazione")
    
    @prenotazione = Prenotazione.new(prenotazione_params)
    @prenotazione.user_id = @current_user.cliente.user.id
    Rails.logger.info("User ID assegnato alla prenotazione: #{@prenotazione.user_id}")
    
    @prenotazione.valida = false  # Impostare valida a false
    Rails.logger.info("Prenotazione impostata come non valida")
  
    if @prenotazione.save
      Rails.logger.info("Prenotazione creata con successo")
      render json: { success: true }
    else
      Rails.logger.error("Errore nella creazione della prenotazione: #{@prenotazione.errors.full_messages.join(", ")}")
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
