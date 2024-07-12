class UserProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]
  before_action :set_user, only: [:show, :edit, :update, :monthly_bookings_user, :daily_bookings_user]

  def show
    @recensioni = Recensione.where(cliente_id: current_user.cliente.id).order(created_at: :desc)
    @iscrizioni = UserCompetition.where(user_id: current_user.cliente.user.id)
    @prenotazioni = Prenotazione.where(user_id: current_user.cliente.user.id).where('data >= ?', Date.today)
    @premi = Premi.where(id: current_user.cliente.user.id)
  end

  def edit
    # @user viene impostato dal before_action :set_user
  end

  def public_show
    @user = User.find(params[:id])
    @iscrizioni = UserCompetition.where(user_id: @user.id)
    @reviews = Recensione.where(cliente_id: @user.cliente.id).order(created_at: :desc).order(pinnata: :desc)
  end

  def daily_bookings_user
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i

    # Formatta la data come stringa 'YYYY-MM-DD'
    formatted_date = Date.new(year, month, day).strftime('%Y-%m-%d')

    # Query per le prenotazioni
    @prenotazioni_oggi = Prenotazione.where(data: formatted_date, valida: true, user_id: @user.cliente.user.id)

    # Renderizza il JSON con tutte le informazioni
    render json: {
      prenotazioni: @prenotazioni_oggi
    }
  end

  def monthly_bookings_user
    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    # Formatta le date come stringhe 'YYYY-MM-DD'
    start_date_str = start_date.strftime('%Y-%m-%d')
    end_date_str = end_date.strftime('%Y-%m-%d')

    # Query per le prenotazioni del mese
    prenotazioni = Prenotazione.where('data >= ? AND data <= ? AND valida = ? AND user_id = ?', start_date_str, end_date_str, true, @user.cliente.user.id)

    render json: {
      bookings: prenotazioni
    }
  end

  private

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end

  def set_user
    @user = @current_user
  end

  def utente_params
    params.require(:utente).permit(:email, :telefono, cliente_attributes: [:id, :foto, user_attributes: [:id, :username, :nome, :cognome, :datanascita]])
  end

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_customer
    unless session[:role] == 'User'
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
    
    Rails.logger.debug "Immagine salvata correttamente in: #{path}" # Utilizzo del logger di Rails
    Rails.logger.debug "Immagine salvata come: #{filename}" # Utilizzo del logger di Rails
    filename
  end

end
