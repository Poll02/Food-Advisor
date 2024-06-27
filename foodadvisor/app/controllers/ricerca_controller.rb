class RicercaController < ApplicationController
    def index
        if params[:query].present?
            @ristoratori = Ristoratori.where('restaurant_name LIKE ?', "%#{params[:query]}%")
          else
            @ristoratori = Ristoratori.limit(10)
          end
    end
end
