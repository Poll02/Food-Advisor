class RegistrationsController < ApplicationController
  def new
    @user = User.new
    @ristoratori = Ristoratori.new
  end

  def create
    Rails.logger.info "Params: #{params.inspect}"
    
    if params[:utente_checkbox].present?
      @user = User.new(user_params.merge(role: 'user'))
      if @user.save
        redirect_to login_path, notice: 'Registrazione utente avvenuta con successo.'
      else
        render :new
      end
    elsif params[:ristoratore_checkbox].present?
      @ristoratori = Ristoratori.new(ristoratore_params.merge(role: 'restaurant_owner'))

      if params[:ristoratori][:photo]
        uploaded_file = params[:ristoratori][:photo]
        file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
        File.open(file_path, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        @ristoratori.photo = uploaded_file.original_filename
      end

      if @ristoratori.save
        redirect_to login_path, notice: 'Registrazione ristoratore avvenuta con successo.'
      else
        render :new
      end
    else
      render :new, alert: 'Seleziona una tipologia di registrazione.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :birth, :email, :phone, :password, :password_confirmation)
  end

  def ristoratore_params
    params.require(:ristoratori).permit(:restaurant_name, :piva, :email, :phone, :password, :password_confirmation, :photo)
  end
end
