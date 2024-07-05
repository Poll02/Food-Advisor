class InfoController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in, except: [:public_show]
  before_action :require_restaurant_owner, except: [:public_show]
  before_action :set_restaurant_owner
  
  def show
    @dipendenti = @restaurant_owner.cliente.ristoratore.dipendentes
    @prenotazioni = Prenotazione.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id, valida: false)
  end

  def create_dipendente
    foto_path = save_locandina(params[:foto]) if params[:foto].present?
  
    @dipendente = Dipendente.new(
      ristoratore_id: @restaurant_owner.cliente.ristoratore.id,
      nome: params[:nome],
      cognome: params[:cognome],
      assunzione: params[:assunzione],
      ruolo: params[:ruolo],
      foto: foto_path
    )
  
    if @dipendente.save
      redirect_to info_path, notice: 'Evento creato con successo.'
    else
      redirect_to info_path, alert: 'Errore nella creazione dell\'evento.'
    end
  rescue ArgumentError => e
    redirect_to info_path, alert: "Errore nella data dell'evento: #{e.message}"
  end

  def destroy_dipendente
    @dipendente = Dipendente.find_by(id: params[:id])
    
    if @dipendente
      if @dipendente.destroy
        render json: { success: true }, status: :ok
      else
        render json: { success: false, error: 'Errore durante l\'eliminazione del dipendente' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: 'Dipendente non trovato' }, status: :not_found
    end
  end

  def bookings_per_week
    start_date = Date.parse(params[:start_date])
    end_date = start_date.end_of_week(:sunday)

    bookings = Prenotazione.where(created_at: start_date.beginning_of_day..end_date.end_of_day, valida: true)
                      .group("DATE(created_at)")
                      .count

    reviews = Recensione.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                    .group("DATE(created_at)")
                    .count

    render json: { bookings: bookings, reviews: reviews }
  end

  def daily_bookings_and_events
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i

    start_date = Date.new(year, month, day).beginning_of_day
    end_date = Date.new(year, month, day).end_of_day

    # Query per le prenotazioni
    @prenotazioni_oggi = Prenotazione.where(data: start_date..end_date, valida: true)

    # Query per gli eventi
    @eventi_oggi = Evento.where(data: start_date..end_date)

    # Puoi aggiungere ulteriori query per altri tipi di dati giornalieri

    # Renderizza il JSON con tutte le informazioni
    render json: {
      prenotazioni: @prenotazioni_oggi,
      eventi: @eventi_oggi,
    }
  end

  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_restaurant_owner
    unless session[:role] == 'Ristoratore'
      redirect_to root_path
    end
  end

  def set_restaurant_owner
    @restaurant_owner = @current_user
  end

  # Metodo per salvare l'immagine in assets/images e restituire il percorso
  def save_locandina(image)
    # Genera un nome univoco per l'immagine
    filename = "#{SecureRandom.hex(8)}_#{image.original_filename}"
    # Percorso completo di salvataggio
    directory = Rails.root.join('app', 'assets', 'images')
    path = File.join(directory, filename)
    # Salva il file nell'immagine
    File.open(path, 'wb') do |file|
      file.write(image.read)
    end
    # Restituisce il percorso relativo dell'immagine
    "/assets/#{filename}"
  end

end
