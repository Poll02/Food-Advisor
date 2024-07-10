class ClassificheController < ApplicationController
    before_action :require_logged_in
    
    def index
        @top_users = User.order(punti: :desc).limit(5)
        @top_restaurants = Ristoratore.all.sort_by(&:media_stelle).reverse.first(5)

        if session[:role] == 'User'
          @competitions = @current_user.cliente.user.competiziones
        elsif session[:role] == 'Critico'
          @competitions = @current_user.cliente.user.competiziones
        elsif session[:role] == 'Ristoratore'
          @competitions = @current_user.ristoratore.competiziones
        else
          @competitions = Competizione.all
        end
    end

    private

    def require_logged_in
        unless logged_in?
          redirect_to login_path
        end
      end
end
