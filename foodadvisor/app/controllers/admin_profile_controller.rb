class AdminProfileController < ApplicationController
  layout 'with_sidebar'
  
  def show
    @clienti = Cliente.all
    @problemi = Problem.all.order(stato: :asc)
    @segnalazioni = Segnalazione.all
  end
end
