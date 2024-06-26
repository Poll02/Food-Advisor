class RestaurateurProfilesController < ApplicationController
  layout :determine_layout
  
  before_action :require_logged_in, except: [:public_show]
  before_action :require_restaurant_owner, except: [:public_show]
  before_action :set_restaurant_owner, only: [:show, :edit, :update, :create_event, :destroy_event, :public_show]
  before_action :set_evento, only: [:destroy_event]

  def show
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
  end

  def edit
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
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
    @evento = Evento.new(
      owner: current_user.id,
      nome: params[:nome],
      data: params[:data],
      luogo: params[:luogo],
      descrizione: params[:descrizione],
      locandina: params[:locandina]
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
    @promotion = Promotion.find(params[:id])

    if @promotion.ristoratore_id == @restaurant_owner.id
      @promotion.destroy
      render json: { success: true }
    else
      render json: { success: false, error: 'Non sei autorizzato a eliminare questa promozione.' }, status: :forbidden
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
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
    @eventi = Evento.where(owner: @restaurant_owner.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: @restaurant_owner.id)
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
end
