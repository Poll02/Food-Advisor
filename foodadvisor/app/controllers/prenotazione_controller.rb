class PrenotazioneController < ApplicationController
  before_action :require_login
  before_action :set_prenotazione, only: [:set_valida, :destroy]

  def create
    ristoratore = Ristoratore.find_by(id: params[:prenotazione][:ristoratore_id])
    
    if session[:role] != 'User' && session[:role] != 'Critico'
      flash[:alert] = "Non puoi effettuare la prenotazione"
      redirect_to public_restaurant_profile_path(ristoratore) and return
    end
  
    Rails.logger.info("Inizio creazione prenotazione")
    Rails.logger.info("parametri passati : #{prenotazione_params.inspect}")
  
    @prenotazione = Prenotazione.new(prenotazione_params)
    Rails.logger.info("vediamo il current user: #{@current_user}")
    #@prenotazione.user_id = @current_user.cliente.user.id
    Rails.logger.info("parametri prenotazione: #{@prenotazione.inspect}")
  
    Rails.logger.info("User ID assegnato alla prenotazione: #{@prenotazione.user_id}")
  
    @prenotazione.valida = false  # Impostare valida a false
    Rails.logger.info("Prenotazione impostata come non valida")
  
    if @prenotazione.save
      flash[:notice] = "Prenotazione creata con successo"
      redirect_to public_restaurant_profile_path(ristoratore)
    else
      flash[:alert] = "Errore nella prenotazione"
      redirect_to public_restaurant_profile_path(ristoratore)
    end
  end
  
  def set_valida
    @prenotazione = Prenotazione.find(params[:id])
  
    if @prenotazione.update(valida: true)
      Rails.logger.info("Prenotazione validata con successo")
      
      # Aggiunta dei punti alle competizioni dell'utente
      user = @prenotazione.user
      user.user_competitions.each do |uc|
        if uc.competizione.data_fine >= Date.today
          uc.punti_competizione += 5
          uc.save!
          Rails.logger.info("Aggiunti 5 punti alla competizione #{uc.competizione.nome}")
        end
      end
      
      render json: { success: true }
    else
      Rails.logger.error("Errore durante la validazione della prenotazione: #{@prenotazione.errors.full_messages}")
      render json: { success: false, error: @prenotazione.errors.full_messages.join(", ") }
    end
  rescue StandardError => e
    Rails.logger.error("Errore durante l'aggiunta dei punti alle competizioni dell'utente: #{e.message}")
    render json: { success: false, error: "Errore durante l'aggiunta dei punti alle competizioni dell'utente" }, status: :internal_server_error
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
    params.require(:prenotazione).permit(:numero_persone, :data, :orario, :ristoratore_id, :user_id)
  end

  def require_login
    unless logged_in?
      render json: { success: false, message: 'Devi essere loggato per effettuare una prenotazione' }
    end
  end
end
