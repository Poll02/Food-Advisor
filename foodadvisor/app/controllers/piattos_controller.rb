class PiattosController < ApplicationController
  layout 'with_sidebar'

  before_action :set_menu

  def new
    @piatto = @menu.piattos.build
  end

  def create
    @piatto = @menu.piattos.build(piattos_params)
    
    if @piatto.save
      redirect_to menus_path(@menu), notice: "Piatto aggiunto con successo"
    else
      render :new
    end
  end

  def destroy
    @piatto = Piatto.find(params[:id])
    @piatto.destroy
    redirect_to menus_path(@menu), notice: "Piatto eliminato con successo"
  end

  private

  def set_menu
    @menu = @current_user.cliente.ristoratore.menu
  end

  def piattos_params
    params.require(:piatto).permit(:nome, :categoria, :prezzo, :foto, :ingredienti)
  end
end
