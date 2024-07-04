class ClassificheController < ApplicationController
    before_action :require_logged_in
    def index
        @competitions = @current_user.cliente.user.competiziones
    end

    private

    def require_logged_in
        unless logged_in?
          redirect_to login_path
        end
      end
end
