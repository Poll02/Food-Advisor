class RestaurateurProfilesController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in
  before_action :require_restaurant_owner
  before_action :set_restaurant_owner, only: [:show, :edit, :create_event, :destroy_event, :update]
  before_action :set_evento, only: [:destroy_event]

  def show
    @eventi = Evento.where(owner: current_user.id).where("data > ?", Date.today)
    @promotions = Promotion.where(ristoratore_id: current_user.id)
  end

  def edit
    @eventi = Evento.where(owner: current_user.id).where("data > ?", Date.today)
  end

  def update
    if @restaurant_owner.update(restaurant_owner_new_params)
      redirect_to show_restaurateur_profiles_path, notice: 'Profilo aggiornato con successo.'
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
      descrizione: params[:descrizione]
    )

    if @evento.save
      redirect_to edit_restaurateur_profiles_path, notice: 'Evento creato con successo.'
    else
      redirect_to edit_restaurateur_profiles_path, alert: 'Errore nella creazione dell\'evento.'
    end
  end

  def destroy_event
    if @evento.owner == current_user.id
      @evento.destroy
      render json: { success: true }
    else
      render json: { success: false, error: 'Non sei autorizzato a eliminare questo evento.' }, status: :forbidden
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
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

  def restaurant_owner_new_params
    params.require(:restaurant_owner).permit(:foto, :restaurant_name, :address, :email, :phone)
  end
end
