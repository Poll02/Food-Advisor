class InfoController < ApplicationController
  layout 'with_sidebar'
  before_action :set_restaurant_owner


  def set_restaurant_owner
    @restaurant_owner = @current_user
  end
  
  def show
    @prenotazioni = Prenotazione.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id)
    @prenotazioni_oggi = Prenotazione.where(ristoratore_id: @restaurant_owner.cliente.ristoratore.id, data: Date.today)

  end
end
