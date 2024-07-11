# app/controllers/competizione_controller.rb
class CompetizioneController < ApplicationController
  before_action :require_login, only: [:join_competition]

  def index
    @competizioni = Competizione.where('data_fine >= ?', Date.today)
    if session[:role] == 'Ristoratore'
      @competizioni_ristoratore = Competizione.where(ristoratore_id: @current_user.cliente.ristoratore.id)
    end
  end

  def create
    Rails.logger.info("inizio creazione competizione")
    @competizione = Competizione.new(competizione_params)
    Rails.logger.info("parametri competizione #{competizione_params}")
    if @competizione.save
      flash[:notice] = 'Competizione creata con successo!'
    else
      Rails.logger.info("Errori di validazione: #{@competizione.errors.full_messages}")
      flash[:alert] = 'Errore durante la creazione della competizione'
    end
    redirect_to competizione_index_path
  end 

  def join_competition
    # Controlla se l'utente è loggato come utente
    if session[:role] != 'User'
      render json: { success: false, error: 'Devi essere loggato come utente per partecipare alle competizioni.' }, status: :unauthorized
      return
    end
  
    Rails.logger.debug "join_competition called with params: #{params.inspect}"
  
    # Trova la competizione tramite l'id passato nei parametri
    competizione = Competizione.find(params[:id])
    Rails.logger.debug "Found competizione: #{competizione.inspect}"
  
    # Controlla se l'utente è già iscritto a questa competizione
    existing_participation = UserCompetition.find_by(user: @current_user.cliente.user, competizione: competizione)
    if existing_participation
      Rails.logger.debug "User already registered for this competition"
      render json: { success: false, error: 'Sei già iscritto a questa competizione.' }
      return
    end

    # Controllo sulla data di iscrizione
    if competizione.data_inizio < Date.today
      render json: { success: false, error: 'La competizione è già iniziata non puoi partecipare.' }
      return
    end
  
    # Controlla se l'utente soddisfa i requisiti della competizione
    if !satisfies_requirements?(competizione)
      Rails.logger.debug "User does not satisfy requirements for this competition"
      render json: { success: false, error: 'Non soddisfi i requisiti per partecipare a questa competizione.' }
      return
    end
  
    Rails.logger.debug "Search user"
    persona = @current_user.cliente.user
    Rails.logger.debug "Found persona: #{persona.inspect}"
  
    # Crea una nuova partecipazione dell'utente alla competizione
    participation = UserCompetition.new(user: persona, competizione: competizione)
    Rails.logger.debug "Created participation: #{participation.inspect}"
  
    # Salva la partecipazione dell'utente
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

  def destroy
    @competizione = Competizione.find(params[:id])

    # Verifica se ci sono partecipazioni associate alla competizione
    if @competizione.user_competitions.any?
      flash[:alert] = 'Non puoi eliminare questa competizione perché ci sono utenti iscritti.'
      redirect_to competizione_index_path
      return
    end

    if @competizione.destroy
      flash[:notice] = 'Competizione eliminata con successo!'
    else
      flash[:alert] = 'Errore durante l\'eliminazione della competizione'
    end
    redirect_to competizione_index_path
  end

  def assegna_punti
    @competizione = Competizione.find(params[:id])

    # Variabile per tenere traccia degli errori
    errors = []

    # Itera su tutte le partecipazioni degli utenti alla competizione
    @competizione.user_competitions.each do |partecipazione|
      # Trova l'utente associato a questa partecipazione
      user = partecipazione.user

      # Aggiungi i punti_competizione alla somma dei punti dell'utente
      if user.update(punti: user.punti + partecipazione.punti_competizione)
        next
      else
        errors << "Errore nell'aggiornamento dei punti per l'utente #{user.id}"
      end
    end

    # Se ci sono stati errori, mostra un alert e interrompi
    if errors.any?
      flash[:alert] = errors.join("<br>").html_safe
      redirect_to competizione_index_path
      return
    end

    # Se tutti gli aggiornamenti sono stati fatti con successo, distruggi la competizione
    if @competizione.destroy
      flash[:notice] = 'Punti assegnati con successo a tutti i partecipanti e competizione eliminata!'
    else
      flash[:alert] = 'Errore durante l\'eliminazione della competizione.'
    end

    #manca la parte di aggiunta buono
    redirect_to competizione_index_path
  end

  private
  
  # Metodo per verificare se l'utente soddisfa i requisiti della competizione
  def satisfies_requirements?(competizione)
    requisiti = competizione.requisiti
    quantitareq = competizione.quantitareq
  
    case requisiti
    when 'nessuno'
      true # Nessun requisito da soddisfare
    when 'prenotazioni'
      # Esempio di controllo requisito: Deve aver effettuato almeno 5 prenotazioni
      @current_user.cliente.user.prenotaziones.count >= quantitareq
    when 'recensioni'
      # Esempio di controllo requisito: Deve aver lasciato almeno 3 recensioni
      @current_user.cliente.recensione.count >= quantitareq
    when 'punti'
      # Esempio di controllo requisito: Deve avere almeno 100 punti
      @current_user.cliente.user.punti >= quantitareq
    else
      false # Requisito non riconosciuto
    end
  end

  def require_login
    unless logged_in?
      Rails.logger.debug "User not logged in"
      render json: { success: false, error: 'Devi essere loggato per partecipare.' }
    end
  end

  # devi salvare localmente la locandina
  def competizione_params
    params.require(:competizione).permit(:nome, :descrizione, :requisiti, :quantitareq, :locandina, :premio, :data_inizio, :data_fine, :ristoratore_id )
    end
end
