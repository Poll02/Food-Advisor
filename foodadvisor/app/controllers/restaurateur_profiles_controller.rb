class RestaurateurProfilesController < ApplicationController
  layout 'with_sidebar'
  
  def show
    #@user = current_user
    render 'dashboard/show'  # Rende la vista specificata
    #da sistemare il reindirizzamento con variabili di sessione dopo aver fatto il login
  end

  def edit
    #@user = current_user
  end

  def update
    #@user = current_user
    #if @user.update(user_params)
    #  redirect_to restaurateur_profile_path, notice: 'Profilo aggiornato con successo.'
    #else
    #  render :edit
    #end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :birth, :role, :email, :password, :password_confirmation, :restaurant_name)
  end

end
