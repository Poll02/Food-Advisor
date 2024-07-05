class ClassificheController < ApplicationController
    before_action :require_logged_in
    def index
        if session[:role] == 'User'
          @competitions = @current_user.cliente.user.competiziones
        end
    end

    private

    def require_logged_in
        unless logged_in?
          redirect_to login_path
        end
      end
end
