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

  def update
    Rails.logger.info("parametri #{params[:stelle]} ---- #{params[:new_comment]}")
    @review=Recensione.find(params[:reviewId])
    if params[:stelle].present? && params[:new_comment].present?
      @review.update(stelle: params[:stelle], commento: params[:new_comment])
    elsif params[:new_comment].present?
      if @review.update(stelle: params[:stelle])
        flash[:notice] = 'Recensione aggiornata con successo!' 
      else
        flash[:alert] = 'Errore durante il salvataggio della recensione'
      end
    elsif params[:new_comment].present?
      if @review.update(commento: params[:new_comment])
        flash[:notice] = 'Recensione aggiornata con successo!'
      else
        flash[:alert] = 'Errore durante il salvataggio della recensione'
      end
    else
      flash[:alert] = 'Errore durante il salvataggio della recensione'
    end
    redirect_to public_restaurant_profile_path(@review.ristoratore_id)
  end

  def destroy
    @restauranteur=@review.ristoratore_id
    if @review.segnalazione.destroy_all && (@review.answer.nil? || @review.answer.destroy) && (@review.assign_stars.nil? || @review.assign_stars.destroy_all) && @review.destroy 
      flash[:notice] = 'Recensione eliminata con successo!'
        @user_type=Admin.where(utente_id: @current_user.id)
        if @user_type.present?
          redirect_to admin_profile_path(@current_user)
        else
          redirect_to public_restaurant_profile_path(@restauranteur)
        end
    else
      Rails.logger.info("PROBLEMA #{@review.errors.full_messages}")
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
    @user_type=Admin.where(utente_id: @current_user.id)
    if @user_type.present?
      @review = Recensione.find(params[:id])
    else
      @review = Recensione.find(params[:Rid])
    end
    
  end

end