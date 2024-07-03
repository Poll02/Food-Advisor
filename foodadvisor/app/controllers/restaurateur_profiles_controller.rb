class RestaurateurProfilesController < ApplicationController 
  layout :determine_layout
  
  before_action :require_logged_in, except: [:public_show]
  before_action :require_restaurant_owner, except: [:public_show]
  before_action :set_restaurant_owner
  before_action :set_evento, only: [:destroy_event]

  def show
    @eventi = Evento.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id).where("data >=?", Date.today)
    @promotions = @restaurant_owner.cliente.ristoratore.promotions
    @tags = @restaurant_owner.cliente.ristoratore.tags
    @recipes = @restaurant_owner.cliente.ristoratore.recipes
  end

  def edit
    load_associated_data # Carica di nuovo i dati associati per la vista edit
  end

  def add_tag
    @tag = Tag.find(params[:tag_id])
    if @restaurant_owner.cliente.ristoratore.tags.exclude?(@tag)
      @restaurant_owner.cliente.ristoratore.tags << @tag
      flash[:success] = "Tag aggiunto con successo."
    else
      flash[:error] = "Il tag è già associato al ristoratore."
    end
    redirect_to edit_restaurateur_profiles_path  # Reindirizza alla pagina di modifica del profilo
  end

  def remove_tag
    @tag = Tag.find(params[:tag_id])
    if @restaurant_owner.cliente.ristoratore.tags.include?(@tag)
      @restaurant_owner.cliente.ristoratore.tags.delete(@tag)
      flash[:success] = "Tag rimosso con successo."
    else
      flash[:error] = "Il tag non è associato al ristoratore."
    end
    redirect_to edit_restaurateur_profiles_path  # Reindirizza alla pagina di modifica del profilo
  end

  def update_info
    puts "PARAMETRI: #{restaurant_owner_new_params.inspect}" # Debug output
    if @restaurant_owner.update(restaurant_owner_new_params)
      redirect_to edit_restaurateur_profiles_path, notice: 'Profilo aggiornato con successo.'
    else
      load_associated_data # Carica di nuovo i dati associati per la vista edit
      render :edit
    end
  end

  def create_event
    locandina_path = save_locandina(params[:locandina]) if params[:locandina].present?
  
    # Converte la stringa di data in un oggetto Date
    event_data = Date.parse(params[:data])
  
    @evento = Evento.new(
      ristoratore_id: @restaurant_owner.cliente.ristoratore.id,
      nome: params[:nome],
      data: event_data,
      luogo: params[:luogo],
      descrizione: params[:descrizione],
      locandina: locandina_path
    )
  
    if @evento.save
      redirect_to edit_restaurateur_profiles_path, notice: 'Evento creato con successo.'
    else
      redirect_to edit_restaurateur_profiles_path, alert: 'Errore nella creazione dell\'evento.'
    end
  rescue ArgumentError => e
    redirect_to edit_restaurateur_profiles_path, alert: "Errore nella data dell'evento: #{e.message}"
  end
  

  def create_promotion
    @promotion = Promotion.new(
      ristoratore_id: @restaurant_owner.cliente.ristoratore.id,
      data_inizio: params[:data_inizio],
      data_fine: params[:data_fine],
      condizioni: params[:condizioni],
      tipo: params[:tipo]
    )

    if @promotion.save
      redirect_to edit_restaurateur_profiles_path, notice: 'Promozione creata con successo.'
    else
      redirect_to edit_restaurateur_profiles_path, alert: 'Errore nella creazione della promozione.'
    end
  end

  def create_recipe
    photo_path = save_locandina(params[:photo]) if params[:photo].present?
  
    @recipe = Recipe.new(
      ristoratore_id: @restaurant_owner.cliente.ristoratore.id,
      name: params[:name],
      difficulty: params[:difficulty],
      ingredients: params[:ingredients],
      procedure: params[:procedure],
      photo: photo_path
    )
  
    if @recipe.save
      redirect_to edit_restaurateur_profiles_path, notice: 'Ricetta creata con successo.'
    else
      redirect_to edit_restaurateur_profiles_path, alert: 'Errore nella creazione della ricetta.'
    end
  end

  def destroy_promotion
    @promotion = Promotion.find_by(id: params[:id])

    if @promotion
      if @promotion.destroy
        render json: { success: true }, status: :ok
      else
        render json: { success: false, error: 'Errore durante l\'eliminazione della promozione' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: 'Promozione non trovata' }, status: :not_found
    end
  end

  def destroy_recipe
    @recipe = Recipe.find_by(id: params[:id])

    if @recipe
      @recipe.destroy
      render json: { success: true }
    else
      render json: { success: false, error: 'Non sei autorizzato a eliminare questa ricetta.' }, status: :forbidden
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def destroy_event
    if @evento.ristoratore_id == @restaurant_owner.cliente.ristoratore.id
      @evento.destroy
      render json: { success: true }
    else
      render json: { success: false, error: 'Non sei autorizzato a eliminare questo evento.' }, status: :forbidden
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  # Nuova azione pubblica per mostrare il profilo vetrina
  def public_show
    @restaurant_owner = Ristoratore.find(params[:id])
    @eventi = Evento.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id).where("data >= ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id)
    @tags = @restaurant_owner.cliente.ristoratore.tags
    @recipes = @restaurant_owner.cliente.ristoratore.recipes
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

  def set_evento
    @evento = Evento.find(params[:id])
  end

  def restaurant_owner_params
    params.require(:ristoratori).permit(:restaurant_name, :email, :phone, :photo)
  end

  def restaurant_owner_new_params
    params.require(:ristoratori).permit(:restaurant_name, :indirizzo, :email, :phone)
  end

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end

  def load_associated_data
    @eventi = Evento.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id)
    @tags = @restaurant_owner.cliente.ristoratore.tags
    @categories = Tag.distinct.pluck(:categoria)
    @recipes = @restaurant_owner.cliente.ristoratore.recipes
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
