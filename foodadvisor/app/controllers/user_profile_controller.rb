class UserProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]

  def show
    @user = @current_user
    @recensioni = Recensione.where(cliente_id: current_user.cliente.id).order(created_at: :desc)
    @iscrizioni = UserCompetition.where(user_id: current_user.cliente.user.id)
    @prenotazioni = Prenotazione.where(user_id: current_user.cliente.user.id).where('data >= ?', Date.today)


    # Logica per la pagina del profilo del cliente
  end

  def public_show
    @user = User.find(params[:id])
  end

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end


  private

  def require_logged_in
    unless logged_in?
      redirect_to login_path
    end
  end

  def require_customer
    unless session[:role] == 'User'
      redirect_to root_path
    end
  end
end
