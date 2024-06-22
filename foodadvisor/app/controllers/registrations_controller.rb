class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Registrazione avvenuta con successo.'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :birth, :role, :email, :phone, :password, :password_confirmation, :restaurant_name)
  end
end
