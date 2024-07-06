# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
    before_action :set_restaurant_owner
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
  
    private
  
    def review_params
        params.permit(:cliente_id, :ristoratore_id, :stelle, :commento) 
    end
  end
  