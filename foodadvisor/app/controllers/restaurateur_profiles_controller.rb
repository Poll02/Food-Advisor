class RestaurateurProfilesController < ApplicationController
  layout :determine_layout
  
  before_action :require_logged_in, except: [:public_show]
  before_action :require_restaurant_owner, except: [:public_show]
  before_action :set_restaurant_owner, only: [:show, :edit, :update, :create_event, :destroy_event, :public_show, :add_tag, :remove_tag]
  before_action :set_evento, only: [:destroy_event]

  def show
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data >=?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
    @tags = @restaurant_owner.tags
  end

  def edit
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
    @tags = @restaurant_owner.tags
    @categories = Tag.distinct.pluck(:categoria)
  end

  def add_tag
    logger.debug "Ristoratore ID: #{@restaurant_owner.id}"
    logger.debug "Tag ID: #{params[:tag_id]}"
    
    choose = Choose.new(ristoratori_id: @restaurant_owner.id, tag_id: params[:tag_id])
    logger.debug "Choose: #{choose.inspect}"
    
    if choose.save
      flash[:notice] = "Tag added successfully."
    else
      logger.debug "Failed to add tag: #{choose.errors.full_messages.join(', ')}"
      flash[:alert] = "Failed to add tag. Errors: #{choose.errors.full_messages.join(', ')}"
    end
    
    redirect_to your_redirect_path
  end
  

  def remove_tag
    choose = Choose.find_by(ristoratori_id: @restaurant_owner.id, tag_id: @tag.id)
    if choose.destroy
      flash[:notice] = "Tag removed successfully."
    else
      flash[:alert] = "Failed to remove tag."
    end
    redirect_to edit_restaurateur_profiles_path # Replace with the appropriate redirect path
  end

  def update
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data > ?", Date.today)
    if @restaurant_owner.update(restaurant_owner_params)
      redirect_to edit_restaurateur_profiles_path, notice: 'Profilo aggiornato con successo.'
    else
      render :edit
    end
  end

  def create_event
    locandina_path = save_locandina(params[:locandina]) if params[:locandina].present?

    @evento = Evento.new(
      owner: current_user.id,
      nome: params[:nome],
      data: params[:data],
      luogo: params[:luogo],
      descrizione: params[:descrizione],
      locandina: locandina_path
    )

    if @evento.save
      redirect_to edit_restaurateur_profiles_path, notice: 'Evento creato con successo.'
    else
      redirect_to edit_restaurateur_profiles_path, alert: 'Errore nella creazione dell\'evento.'
    end
  end

  def create_promotion
    @promotion = Promotion.new(
      ristoratore_id: current_user.id,
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

  def destroy_event
    if @evento.owner == @restaurant_owner.id
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
    @restaurant_owner = Ristoratori.find(params[:id])
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data >= ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
    @tags = @restaurant_owner.tags
  end

  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_restaurant_owner
    unless current_user.role == 'restaurant_owner'
      redirect_to root_path
    end
  end

  def set_restaurant_owner
    @restaurant_owner = current_user
  end

  def set_evento
    @evento = Evento.find(params[:id])
  end

  def restaurant_owner_params
    params.require(:ristoratori).permit(:restaurant_name, :email, :phone, :foto)
  end

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
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
