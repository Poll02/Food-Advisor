# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_restaurant_owner, only: [:create]
  before_action :set_review, only: [:destroy]
  before_action :find_review, only: [:add_like]

  def create
    @review = Recensione.new(
      stelle: params[:stelle],
      commento: params[:commento]
    )
    @review.cliente = @current_user.cliente
    @review.ristoratore = @restaurant_owner.ristoratore
    
    if @review.save
      # Aggiunta di due punti a punti_competizione di UserCompetition associata per competizioni attive
      @current_user.cliente.user.user_competitions.each do |uc|
        if uc.competizione.data_fine >= Date.today
          uc.punti_competizione += 2
          uc.save!
          Rails.logger.info("Aggiunti 2 punti alla competizione #{uc.competizione.nome} per l'utente #{uc.user.nome}")
        end
      end
  
      flash[:notice] = 'Recensione salvata con successo!'
      redirect_to public_restaurant_profile_path(@review.ristoratore_id)
    else
      flash[:alert] = 'Errore durante il salvataggio della recensione'
      redirect_back(fallback_location: root_path)
    end
  end  

  def destroy
      logger.info "ID: #{@review.id}"
      logger.info "Cliente: #{@review.cliente_id}"
      logger.info "Cliente: #{@review.ristoratore_id}"
      logger.info "Stelle: #{@review.stelle}"
      logger.info "Commento: #{@review.commento}"
      logger.info "Data creazione: #{@review.created_at}"
    if @review.segnalazione.destroy_all && @review.destroy
      flash[:notice] = 'Recensione eliminata con successo!'
        redirect_to admin_profile_path(@current_user)
    else
      flash[:alert] = 'Errore durante la rimozione della recensione'
      redirect_back(fallback_location: root_path)
    end
  end

  def add_like
    if @review.cliente_id == current_user.cliente.id
      flash[:alert] = "Non puoi mettere like alle tue stesse recensioni."
    else
      @review.increment!(:like)
      flash[:notice] = "Like aggiunto con successo."
    end
    redirect_to public_restaurant_profile_path(params[:restaurant_owner_id])
  end

  private

  def find_review
    Rails.logger.info("sto iniziando la ricerca della recensione")
    @review = Recensione.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Recensione non trovata."
    redirect_to public_restaurant_profile_path(params[:restaurant_owner_id])
  end

  def set_restaurant_owner
    @restaurant_owner = Cliente.find(params[:ristoratore_id])
  end

  def set_review
    @review = Recensione.find(params[:id])
  end

end
