class CriticProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]

  def show
  end

  def public_show
    @critico = Critico.find(params[:id])
  end

  def edit
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
    unless session[:role] == 'Critico'
      redirect_to root_path
    end
  end
end
