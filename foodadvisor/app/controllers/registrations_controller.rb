class RegistrationsController < ApplicationController
  def new
    @user = User.new
    @ristoratore = Ristoratori.new
  end

  def create
    if params[:utente_checkbox].present?
      @user = User.new(user_params)
      if @user.save
        redirect_to root_path, notice: 'Registrazione utente avvenuta con successo.'
      else
        render :new
      end
    elsif params[:ristoratore_checkbox].present?
      @ristoratore = Ristoratori.new(ristoratore_params)
      if @ristoratore.save
        redirect_to root_path, notice: 'Registrazione ristoratore avvenuta con successo.'
      else
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :birth, :email, :phone, :password, :password_confirmation)
  end

  def ristoratore_params
    params.permit(:restaurant_name, :piva, :email, :phone, :password, :password_confirmation, :foto)
  end
end

