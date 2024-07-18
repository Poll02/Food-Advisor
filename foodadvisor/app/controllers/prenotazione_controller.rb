class PrenotazioneController < ApplicationController
  before_action :require_login
  before_action :set_prenotazione, only: [:set_valida, :destroy]

  def create
    ristoratore = Ristoratore.find_by(id: params[:prenotazione][:ristoratore_id])
    
    if session[:role] != 'User' && session[:role] != 'Critico'
      flash[:alert] = "Non puoi effettuare la prenotazione"
      redirect_to public_restaurant_profile_path(ristoratore) and return
    end
  
    @prenotazione = Prenotazione.new(prenotazione_params)
  
    @prenotazione.valida = false  # Impostare valida a false
  
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
      # Aggiunta dei punti alle competizioni dell'utente
      user = @prenotazione.user
      user.user_competitions.each do |uc|
        if uc.competizione.data_fine >= Date.today
          uc.punti_competizione += 5
          uc.save!
        end
      end
          flash[:notice] = 'Prenotazione aggiornata con successo.'
          redirect_to info_path
    else
      flash[:alert] = 'Errore durante la validazione della prenotazione'
      redirect_to info_path
    end
  rescue StandardError => e
    flash[:alert] = 'Errore durante l\'aggiunta dei punti alle competizioni dell\'utente'
    redirect_to info_path

  end

  def destroy
    @prenotazione.destroy
    flash[:notice] = 'Prenotazione eliminata'
    redirect_to info_path
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
