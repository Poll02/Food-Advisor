class SegnalazionesController < ApplicationController
  before_action :set_recensione
    def create
      @segnalazione = Segnalazione.new(
        motivo: params[:commento],
      )
      @segnalazione.recensione = @recensione
      @segnalazione.cliente = @current_user.cliente
      if @segnalazione.save
        flash[:notice] = 'Segnalazione salvata con successo!'
        redirect_to public_restaurant_profile_path(@recensione.ristoratore_id)
      else
        flash[:alert] = 'Errore durante il salvataggio della recensione'
        redirect_back(fallback_location: root_path)
      end
    end

    private

    def set_recensione
      @recensione = Recensione.find(params[:recensione_id])
    end
  end
  