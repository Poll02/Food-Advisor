class SegnalazionesController < ApplicationController
  before_action :set_recensione
    
  def create
    @segnalazione = Segnalazione.new(
      motivo: params[:commento]
    )
    @segnalazione.recensione = @recensione
    @segnalazione.cliente = @current_user.cliente
    
    if @segnalazione.save
      # Aggiunta di due punti a punti_competizione di UserCompetition associata per competizioni attive
      recensione_cliente = @recensione.cliente
      recensione_cliente.user.user_competitions.each do |uc|
        if uc.competizione.data_fine >= Date.today
          uc.punti_competizione -= 2
          uc.save!
          Rails.logger.info("Aggiunti 2 punti alla competizione #{uc.competizione.nome} per l'utente #{uc.user.nome}")
        end
      end
  
      flash[:notice] = 'Segnalazione salvata con successo!'
      redirect_to public_restaurant_profile_path(@recensione.ristoratore_id)
    else
      flash[:alert] = 'Errore durante il salvataggio della segnalazione'
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

  def set_recensione
      @recensione = Recensione.find(params[:recensione_id])
  end
end
  