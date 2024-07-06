class UserProfileController < ApplicationController
  layout :determine_layout

  before_action :require_logged_in, except: [:public_show]
  before_action :require_customer, except: [:public_show]
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @recensioni = Recensione.where(cliente_id: current_user.cliente.id).order(created_at: :desc)
    @iscrizioni = UserCompetition.where(user_id: current_user.cliente.user.id)
    @prenotazioni = Prenotazione.where(user_id: current_user.cliente.user.id).where('data >= ?', Date.today)
  end

  def edit
    # @user viene impostato dal before_action :set_user
  end

  def update
    if @user.update(utente_params)
      Rails.logger.debug "Impostazioni profilo aggiornate" # Utilizzo del logger di Rails
      # Se la foto è stata aggiornata, copiala in assets/images
      if params[:utente][:cliente_attributes][:foto].present?
        Rails.logger.debug "presente immagine" # Utilizzo del logger di Rails
        photo_path = save_locandina(params[:utente][:cliente_attributes][:foto])
        @user.cliente.foto = photo_path
        Rails.logger.debug "in user ho: #{@user.cliente.foto}" # Utilizzo del logger di Rails
      end
      redirect_to user_profile_path, notice: 'I tuoi dettagli sono stati aggiornati con successo.'
    else
      flash[:error] = 'Errore durante l\'aggiornamento del profilo.'
      render :edit
    end
  rescue ActiveRecord::InvalidForeignKey => e
    flash[:error] = "Errore durante l'aggiornamento del profilo: #{e.message}"
    render :edit
  end  

  def public_show
    @user = User.find(params[:id])
  end

  def determine_layout
    action_name == 'public_show' ? 'application' : 'with_sidebar'
  end

  private

  def set_user
    @user = @current_user
  end

  def utente_params
    params.require(:utente).permit(:email, :telefono, cliente_attributes: [:id, :foto, user_attributes: [:id, :username, :nome, :cognome, :datanascita]])
  end

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

  def save_locandina(image)
    # Genera un nome univoco per l'immagine
    filename = "#{SecureRandom.hex(8)}_#{image.original_filename}"
    # Percorso completo di salvataggio
    directory = Rails.root.join('app', 'assets', 'images')
    FileUtils.mkdir_p(directory) unless File.directory?(directory) # Crea la directory se non esiste
    path = File.join(directory, filename)
    # Salva il file nell'immagine
    File.open(path, 'wb') do |file|
      file.write(image.read)
    end
    
    Rails.logger.debug "Immagine salvata correttamente in: #{path}" # Utilizzo del logger di Rails
    Rails.logger.debug "Immagine salvata come: #{filename}" # Utilizzo del logger di Rails
    filename
  end

end
