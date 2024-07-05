class MenusController < ApplicationController
  layout 'with_sidebar'

  before_action :set_ristoratore
  before_action :set_menu

  def show
    @piattos = @menu.piattos

    if params[:query].present?
      @piattos = @piattos.where('nome LIKE ?', "%#{params[:query]}%")
    end

    if params[:categoria].present?
      @piattos = @piattos.where(categoria: params[:categoria])
    end

    if params[:prezzoMin].present?
      @piattos = @piattos.where('prezzo >= ?', params[:prezzoMin].to_f)
    end

    if params[:prezzoMax].present?
      @piattos = @piattos.where('prezzo <= ?', params[:prezzoMax].to_f)
    end

    if params[:ingredienti].present?
      ingredienti = params[:ingredienti].split(',').map(&:strip)
      ingredienti.each do |ingrediente|
        @piattos = @piattos.where('ingredienti LIKE ?', "%#{ingrediente}%")
      end
    end

    @categories = @piattos.map { |piatto| piatto.categoria }.uniq
  end

  def edit
    @piattos = @menu.piattos
    @categories = @piattos.map { |piatto| piatto.categoria }.uniq
  end

  private

  def set_ristoratore
    @restaurateur_profile = @current_user.cliente.ristoratore
  end

  def set_menu
    @menu = @restaurateur_profile.menu
  end
end
