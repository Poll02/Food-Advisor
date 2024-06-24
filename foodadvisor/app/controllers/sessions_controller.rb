# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  
  def new
    if logged_in?
      redirect_to root_path
    end
  end

  def create
    if request.env['omniauth.auth'] # Login tramite Google
      user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to root_path
    else # Login normale
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in(user)
        redirect_to root_path
      else
        flash.now[:alert] = 'Combinazione email/password non valida'
        render 'new'
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
