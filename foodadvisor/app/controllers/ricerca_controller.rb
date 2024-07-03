class RicercaController < ApplicationController
    def index
        if params[:query].present?
            @ristoratori = Ristoratore.includes(cliente: :utente).where('nomeristorante LIKE ?', "%#{params[:query]}%")
          else
            @ristoratori = Ristoratore.limit(10)
          end
    end
end
