# app/controllers/competizione_controller.rb
class CompetizioneController < ApplicationController
  before_action :require_login, only: [:join_competition]

  def index
  @competizioni = Competizione.all
  end


  def join_competition
    Rails.logger.debug "join_competition called with params: #{params.inspect}"

    competizione = Competizione.find(params[:id])
    Rails.logger.debug "Found competizione: #{competizione.inspect}"

    existing_participation = UserCompetition.find_by(user: @current_user.cliente.user, competizione: competizione)

    if existing_participation
      Rails.logger.debug "User already registered for this competition"
      render json: { success: false, error: 'Sei già iscritto a questa competizione.' }
      return
    end

    Rails.logger.debug "Search user"
    persona = @current_user.cliente.user
    Rails.logger.debug "Found persona: #{persona.inspect}"

    participation = UserCompetition.new(user: persona, competizione: competizione)
    Rails.logger.debug "Created participation: #{participation.inspect}"

    if participation.save
      Rails.logger.debug "Participation saved successfully"
      render json: { success: true }
    else
      Rails.logger.debug "Error saving participation: #{participation.errors.full_messages.to_sentence}"
      render json: { success: false, error: participation.errors.full_messages.to_sentence }
    end
  rescue => e
    Rails.logger.error "Exception: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { success: false, error: 'Internal Server Error' }, status: 500
  end

  private

  def require_login
    unless logged_in?
      Rails.logger.debug "User not logged in"
      render json: { success: false, error: 'Devi essere loggato per partecipare.' }
    end
  end
end
