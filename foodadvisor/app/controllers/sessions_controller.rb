# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to root_path, notice: "Login effettuato con successo!"
    else
      flash.now[:alert] = 'Combinazione email/password non valida'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
