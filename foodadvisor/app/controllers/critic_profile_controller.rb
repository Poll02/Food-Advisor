class CriticProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in, except: [:public_show]
  before_action :require_critico, except: [:public_show]
  before_action :set_critico, only: [:show, :edit, :update, :monthly_bookings, :daily_bookings]

  def public_show
    @critico = Critico.find(params[:id])
    @iscrizioni = UserCompetition.where(user_id: @critico.user.id)
    @reviews = Recensione.where(cliente_id: @critico.user.cliente.id).order(created_at: :desc).order(pinnata: :desc)

    @posizioni = {}
    @iscrizioni.each do |iscrizione|
      competizione = Competizione.find(iscrizione.competizione_id)
      @posizioni[competizione.id] = competizione.posizione_utente(@critico.user.id)
    end
  end

  def show
    @recensioni = Recensione.where(cliente_id: current_user.cliente.id).order(created_at: :desc)
    @iscrizioni = UserCompetition.where(user_id: current_user.cliente.user.id)
    @prenotazioni = Prenotazione.where(user_id: current_user.cliente.user.id).where('data >= ?', Date.today)
    @premi = Premi.where(id: current_user.cliente.user.id)
  end

  def edit
  end

  def update
    if @critico.update(utente_params)
      # Se la foto è stata aggiornata, copiala in assets/images
      if params[:utente][:cliente_attributes][:foto].present?
        photo_path = save_locandina(params[:utente][:cliente_attributes][:foto])
        @critico.cliente.foto = photo_path
      end
      redirect_to critic_profile_path, notice: 'I tuoi dettagli sono stati aggiornati con successo.'
    else
      flash[:error] = 'Errore durante l\'aggiornamento del profilo.'
      render :edit
    end
  rescue ActiveRecord::InvalidForeignKey => e
    flash[:error] = "Errore durante l'aggiornamento del profilo: #{e.message}"
    render :edit
  end  

  def daily_bookings
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i

    # Formatta la data come stringa 'YYYY-MM-DD'
    formatted_date = Date.new(year, month, day).strftime('%Y-%m-%d')

    # Query per le prenotazioni
    @prenotazioni_oggi = Prenotazione.where(data: formatted_date, valida: true, user_id: @critico.cliente.user.id)

    # Renderizza il JSON con tutte le informazioni
    render json: {
      prenotazioni: @prenotazioni_oggi
    }
  end

  def monthly_bookings
    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    # Formatta le date come stringhe 'YYYY-MM-DD'
    start_date_str = start_date.strftime('%Y-%m-%d')
    end_date_str = end_date.strftime('%Y-%m-%d')

    # Query per le prenotazioni del mese
    prenotazioni = Prenotazione.where('data >= ? AND data <= ? AND valida = ? AND user_id = ?', start_date_str, end_date_str, true, @critico.cliente.user.id)

    render json: {
      bookings: prenotazioni
    }
  end

  private

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end

  def set_critico
    @critico = @current_user
  end

  def utente_params
    params.require(:utente).permit(:email, :telefono, cliente_attributes: [:id, :foto, user_attributes: [:id, :username, :nome, :cognome, :datanascita, critico_attributes: [:id, :certificato]]])
  end

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_critico
    unless session[:role] == 'Critico'
      redirect_to root_path
    end
  end

  def save_locandina(image)
    # Genera un nome univoco per l'immagine
    filename = "#{SecureRandom.hex(8)}_#{image.original_filename}"
    # Percorso completo di salvataggio
    directory = Rails.root.join('app', 'assets', 'images')
    FileUtils.mkdir_p(directory) unless File.directory?(directory) # Crea la directory se non esiste
    path = File.join(directory, filename)
    # Salva il file nell'immagine
    File.open(path, 'wb') do |file|
      file.write(image.read)
    end
    
    filename
  end

end
