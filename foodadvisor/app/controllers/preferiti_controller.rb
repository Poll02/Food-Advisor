class PreferitiController < ApplicationController
  layout 'with_sidebar'

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]
  def show
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

