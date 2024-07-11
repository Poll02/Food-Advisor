class AdminProfileController < ApplicationController
  layout 'with_sidebar'
  
  def show
    @clienti = Cliente.all
    @problemi = Problem.all.order(stato: :asc)
    @segnalazioni = Segnalazione.includes(:recensione)
  end
end
