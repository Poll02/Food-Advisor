class InfoController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in, except: [:public_show]
  before_action :require_restaurant_owner, except: [:public_show]
  before_action :set_restaurant_owner
  
  def show
    @dipendenti = @restaurant_owner.cliente.ristoratore.dipendentes
    @prenotazioni = Prenotazione.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id, valida: false)
  end

  def bookings_per_week
    
    start_date = Date.parse(params[:start_date])
    end_date = start_date.end_of_week(:sunday) + 1.day
    rist = @restaurant_owner.cliente.ristoratore.id
  
    bookings = Prenotazione.where(data: start_date..end_date, valida: true, ristoratore_id: rist)
                           .group("DATE(data)")
                           .count
  
    reviews = Recensione.where(ristoratore_id: rist, created_at: start_date.beginning_of_day..end_date.end_of_day)
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

  def create_dipendente
    @dipendente = Dipendente.new(dipendente_params)

    if params[:dipendente][:foto]
      uploaded_file = params[:dipendente][:foto]
      file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      @dipendente.foto = uploaded_file.original_filename
    end

    if @dipendente.save
      flash[:notice] = 'Dipendente creato con successo.'
    else
      flash[:alert] = 'Errore nella creazione.'
    end
    redirect_to info_path
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

  def dipendente_params
    params.require(:dipendente).permit(:foto, :nome, :cognome, :ruolo, :assunzione, :ristoratore_id)
  end

end