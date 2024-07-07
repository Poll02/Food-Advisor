# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_restaurant_owner, only: [:create]
  before_action :set_review, only: [:destroy]

  def create
      @review = Recensione.new(
        stelle: params[:stelle],
        commento: params[:commento]
      )
      @review.cliente = @current_user.cliente
      @review.ristoratore = @restaurant_owner.ristoratore
      if @review.save
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

  private


  def set_restaurant_owner
    @restaurant_owner = Cliente.find(params[:ristoratore_id])
  end

  def set_review
    @review = Recensione.find(params[:id])
  end

end
