# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_restaurant_owner, only: [:create]
  before_action :set_review, only: [:destroy]
  before_action :find_review, only: [:add_like]

  def create
    unless ['User', 'Critico'].include?(session[:role])
      flash[:alert] = 'Non puoi lasciare una recensione'
      return redirect_back(fallback_location: root_path)
    end
  
    @review = Recensione.new(
      stelle: params[:stelle],
      commento: params[:commento],
      cliente: @current_user.cliente,
      ristoratore: @restaurant_owner.ristoratore
    )
  
    if @review.save
      competizioni_associate = @current_user.cliente.user.competiziones
      competizioni_associate.each do |competizione|
        if competizione.data_fine >= Date.today
          user_competition = UserCompetition.find_by(user_id: @current_user.cliente.user.id, competizione_id: competizione.id)
          if user_competition
            user_competition.punti_competizione += 2
            user_competition.save!
          end
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
      
      flash[:alert] = 'Errore durante la rimozione della recensione'
      redirect_back(fallback_location: root_path)
    end
  end

  def add_like
    recensione = Recensione.find(params[:review_id])
    cliente_id = params[:cliente_id].to_i
    cliente = Cliente.find(params[:cliente_id])

    Rails.logger.info("cerco l'istanza di cliente associata alla recensione ")
    assign_star = recensione.assign_stars.find_by(cliente_id: cliente_id)

    if assign_star
      Rails.logger.info("trovata l'istanza di cliente associata alla recensione: hai già messo like")
      message = "Hai già messo like a questa recensione"
    elsif recensione.cliente_id == params[:cliente_id]
      Rails.logger.info("è la tua stessa recensione")
      message = "Non puoi mettere like a una tua recensione"
    else
      Rails.logger.info("non ho trovato l'istanza di cliente associata alla recensione: puoi lasciare il like")
      assign_star = recensione.assign_stars.create(cliente_id: cliente_id)

      Rails.logger.info("incremento il num di like")
      recensione.increment!(:like)

      # punti
      Rails.logger.info("se il clie nte partecipa a delle competizioni gli aggiungo dei punti")
      competizioni_attive = recensione.cliente.user.competiziones.where("data_fine >= ?", Date.today)
      if competizioni_attive.any?

        # Per ogni competizione attiva, aggiungi punti_competizione
        Rails.logger.info("aggiungo i punti")
        competizioni_attive.each do |competizione|
          if session[:role] == 'Critico'
            UserCompetition.find_by(user_id: recensione.cliente.user.id).increment!(:punti_competizione, 3)
          else
            UserCompetition.find_by(user_id: recensione.cliente.user.id).increment!(:punti_competizione, 2)
          end
        end
      end

      message = "Like aggiunto con successo!"
    end

    respond_to do |format|
      format.html { redirect_to public_restaurant_profile_path(params[:restaurant_owner_id]), notice: message }
      format.json { render json: { message: message } }
    end
  end

  private

  def find_review
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