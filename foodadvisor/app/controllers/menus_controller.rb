class MenusController < ApplicationController
  layout 'with_sidebar'

  before_action :set_ristoratore
  before_action :set_menu

  def show
    @piattos = @menu.piattos
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
