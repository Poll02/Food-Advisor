class HomeController < ApplicationController
  def index
    @recent_restaurants = Ristoratore.includes(cliente: :utente).where("ristoratores.created_at >= ?", 30.days.ago).order(created_at: :desc).limit(10)
    @upcoming_events = Evento.where("data >= ?", Date.today).order(data: :asc)
    @reviews = Recensione.top_rated
  end
end
