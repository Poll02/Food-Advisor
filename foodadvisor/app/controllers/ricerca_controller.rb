class RicercaController < ApplicationController
    def index
        if params[:query].present?
            @ristoratori = Ristoratore.includes(cliente: :utente).where('nomeristorante LIKE ?', "%#{params[:query]}%")
          else
            @ristoratori = Ristoratore.limit(10)
          end
    end

    def map_info
      ristoratore = Ristoratore.find(params[:id])
      render json: { name: ristoratore.format_restaurant_name }
    end
end
