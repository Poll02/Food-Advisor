class AdminProfileController < ApplicationController
  layout 'with_sidebar'
  before_action :set_cliente, only: [:destroy]
  def show
    @clienti = Cliente.all
    @problemi = Problem.all.order(stato: :asc)
    @segnalazioni = Segnalazione.all
  end

  def destroy
    if @ristoratore.present?
      if @ristoratore.destroy && @cliente.destroy && @cliente.utente.destroy
        flash[:notice] = "Ristoratore eliminato con successo!"
      else
        flash[:alert] = "Errore nell'eliminazione dell'utente!"
      end
    elsif @user.present?
      if @critico.present?
        if @critico.destroy && @user.destroy && @cliente.destroy && @cliente.utente.destroy
          flash[:notice] = "Critico eliminato con successo!"
        else
          flash[:alert] = "Errore nell'eliminazione dell'utente!"
        end
      else
        if @user.destroy && @cliente.destroy && @cliente.utente.destroy
          flash[:notice] = "User eliminato con successo!"
        else
          flash[:alert] = "Errore nell'eliminazione dell'utente!"
        end
      end
    end
    redirect_to admin_profile_path(@current_user)
  end

  private

  def set_cliente
    @cliente = Cliente.find(params[:delete_id])
    @user = User.find_by(cliente_id: params[:delete_id])
    @critico = Critico.find_by(user_id: @user.id)
    @ristoratore = Ristoratore.find_by(cliente_id: params[:delete_id])
  end
end
