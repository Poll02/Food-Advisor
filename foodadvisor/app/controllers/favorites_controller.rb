# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
    before_action :require_login
  
    def add_rest_to_favorites
      ristoratore_id = params[:ristoratore_id]
      if session[:role] == 'User'
        user_id = current_user.cliente.user.id
      else
        render json: { success: false, error: 'Devi essere loggato come utente per aggiungere ai preferiti.' }, status: :unauthorized
      end


  
      if FavRistoranti.exists?(user_id: user_id, ristoratore_id: ristoratore_id)
        render json: { success: false, error: 'Ristorante già nei preferiti' }, status: :unprocessable_entity
      else
        favorite = FavRistoranti.new(user_id: user_id, ristoratore_id: ristoratore_id)
  
        if favorite.save
          render json: { success: true }
        else
          render json: { success: false, error: favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    end

    def add_recipe_to_favorites
      recipe_id = params[:recipe_id]
      if session[:role] == 'User'
        user_id = current_user.cliente.user.id
      else
        render json: { success: false, error: 'Devi essere loggato come utente per aggiungere ai preferiti.' }, status: :unauthorized
      end


  
      if FavRecipe.exists?(user_id: user_id, recipe_id: recipe_id)
        render json: { success: false, error: 'Ricetta già nei preferiti' }, status: :unprocessable_entity
      else
        favorite = FavRecipe.new(user_id: user_id, recipe_id: recipe_id)
  
        if favorite.save
          render json: { success: true }
        else
          render json: { success: false, error: favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    end

    def add_event_to_favorites
      evento_id = params[:evento_id]
      Rails.logger.info("Prendo id evento #{evento_id}" )

      if session[:role] == 'User'
        user_id = current_user.cliente.user.id
        Rails.logger.info("Set user id #{user_id}" )

      else
        render json: { success: false, error: 'Devi essere loggato come utente per aggiungere ai preferiti.' }, status: :unauthorized
      end


  
      if FavEvents.exists?(user_id: user_id, event_id: evento_id)
        render json: { success: false, error: 'Ristorante già nei preferiti' }, status: :unprocessable_entity
      else
        Rails.logger.info("Inizio creazione" )

        favorite = FavEvents.new(user_id: user_id, event_id: evento_id)
        Rails.logger.info("Debug #{evento_id}" )



  
        if favorite.save
          Rails.logger.info("Fine creazione" )

          render json: { success: true }
        else
          render json: { success: false, error: favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    end
  
    private
  
    def require_login
      unless logged_in?
        render json: { success: false, error: 'Devi essere loggato per aggiungere ai preferiti.' }, status: :unauthorized
      end
    end
  end
  