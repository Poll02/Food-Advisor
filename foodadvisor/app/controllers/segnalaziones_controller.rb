class SegnalazionesController < ApplicationController
  before_action :set_recensione

  def index
    @segnalazioni = Segnalazione.where(cliente_segnalato_id: params[:cliente_id])
    render json: @segnalazioni
  end

  def destroy
    segnalazioni_da_elim =Segnalazione.where(cliente_segnalato_id:  params[:data_id])

    # Verifica se ci sono segnalazioni da eliminare
    if segnalazioni_da_elim.present?
      # Elimina le segnalazioni
      segnalazioni_da_elim.destroy_all
      flash[:notice] = "Segnalazioni eliminate con successo!"
    else
      flash[:alert] = "Nessuna segnalazione selezionata per l'eliminazione."
    end
    redirect_to admin_profile_path(@current_user)
  end
    
  def create
    @segnalazione = Segnalazione.new(
      motivo: params[:commento]
    )
    
    @segnalazione.cliente = @current_user.cliente
    if @recensione.present?
      @segnalazione.cliente_segnalato = @recensione.cliente
      @segnalazione.recensione_id = @recensione.id
    end
    if @ristorante.present?
      @segnalazione.cliente_segnalato = @ristorante.cliente
    end
    if @user.present?
      @segnalazione.cliente_segnalato = @user.cliente
    end
    if @segnalazione.save
      
  
      flash[:notice] = 'Segnalazione salvata con successo! La segnalazione verrà verificata da un admin!'
      if @recensione.present?
        redirect_to public_restaurant_profile_path(@recensione.ristoratore_id)
      elsif @ristorante.present?
        redirect_to public_restaurant_profile_path(@ristorante)
      elsif @user.present?
        redirect_to public_user_profile_path(@user)
      end
    else
      flash[:alert] = 'Errore durante il salvataggio della segnalazione'
      redirect_back(fallback_location: root_path)
    end
  end
  
  private

  def set_recensione
      if params[:type]=='recensione'
        
        @recensione = Recensione.find(params[:data_id])
      elsif params[:type]=='ristorante'
        @ristorante = Ristoratore.find(params[:data_id])
      elsif params[:type]=='user'
        @user = User.find(params[:data_id])
      end
  end
end
  