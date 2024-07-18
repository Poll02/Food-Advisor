class AdminProfileController < ApplicationController
  layout 'with_sidebar'
  before_action :set_utente, only: [:destroy]
  def show
    @clienti = Cliente.all
    @problemi = Problem.all.order(stato: :asc)
    @segnalazioni = Segnalazione.all
  end

  def destroy
    if @utente.destroy
      flash[:notice] = "Utente eliminato con successo"
    else
      flash[:alert] = "Errore nell'eliminazione dell'utente"
    end
    redirect_to admin_profile_path(@current_user)
  end

  private

  def set_utente
    @utente = Utente.find(params[:delete_id])
  end
end
