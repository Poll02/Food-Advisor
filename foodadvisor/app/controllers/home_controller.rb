class HomeController < ApplicationController
  def index
    @recent_restaurants = Ristoratori.where("created_at >= ?", 30.days.ago).order(created_at: :desc).limit(10)
    @eventi = Evento.where("data >=?", Date.today).order(created_at: :desc).limit(10) 
  end
end
