class SettingsController < ApplicationController
  before_action :authenticate_user! # Assicuriamoci che l'utente sia autenticato
  before_action :set_user
  before_action :set_setting  

  layout 'with_sidebar'

  def show
  end

  def edit
  end

  def update
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Impostazioni aggiornate con successo.'
    else
      render :edit
    end
  end

  def update_credentials  
    # Controlla la password se è presente
    if params[:utente][:password].present?
      # Controllo della complessità della password
      unless params[:utente][:password] =~ /^(?=.*[A-Z]).{4,}$/  # Almeno una lettera maiuscola e lunga almeno 4 caratteri
        flash[:alert] = 'La nuova password deve contenere almeno una lettera maiuscola e essere lunga almeno 4 caratteri.'
        render :edit
        return
      end
  
      # Se la password è stata inserita, annulla la temporanea e distruggi la sessione
      @current_user.update(tmp_password: nil)
    end
  
    # Controllare la password corrente
    if params[:current_password].present? && @current_user.authenticate(params[:current_password])
      logger.info "Password corrente corretta."
  
      # Se password_digest è nil, impostarlo alla password corrente
      if params[:utente][:password].blank?
        @current_user.password = params[:current_password]
        @current_user.password_confirmation = params[:current_password]
        logger.info "Password digest era nil, impostato alla password corrente."
      end
  
      # Gestione del caricamento della foto per cliente
      if session[:role] != 'Admin' && params[:utente][:cliente_attributes][:foto]
        uploaded_file = params[:utente][:cliente_attributes][:foto]
        file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
        File.open(file_path, 'wb') do |file|
          file.write(uploaded_file.read)
        end
        params[:utente][:cliente_attributes][:foto] = uploaded_file.original_filename
      end
  
      # Aggiornamento delle informazioni dell'utente
      if @current_user.update(user_params)
        # Reindirizza l'utente con un messaggio di successo
        logger.info "Aggiornamento credenziali riuscito."
        flash[:notice] = 'Credenziali aggiornate con successo.'
        redirect_to settings_path
      else
        # Rendi la vista del form con errori
        logger.error "Errore aggiornamento credenziali: #{current_user.errors.full_messages.join(", ")}"
        flash[:alert] = 'Errore aggiornamento credenziali.'
        render :edit
      end
    else
      logger.error "Password corrente non corretta o non presente."
      flash[:alert] = 'Password corrente non corretta.'
      render :edit
    end
  end 
  

  def destroy
    begin
      @user.destroy

      session[:utente_id] = nil  # Assicurati di eliminare anche la sessione

      redirect_to root_path, notice: "Account cancellato con successo."
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Utente non trovato."
    end
  end

  private

  def user_params
    params.require(:utente).permit(
      :email,
      :password,
      :password_confirmation,
      cliente_attributes: [
        :id,
        :foto,
        ristoratore_attributes: [
          :id,
          :nomeristorante,
          :piva,
          :indirizzo
        ],
        user_attributes: [
          :id,
          :username,
          :nome,
          :cognome
        ]
      ],
      admin_attributes: [
        :id,
        :nome,
        :cognome
      ]
    )
  end  

  def set_user
    @user = current_user
  end

  def set_setting
    @setting = Setting.find_by(utente_id: @user.id)
  end

  def setting_params
    params.require(:setting).permit(:font, :font_size, :theme)
  end

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Devi effettuare il login per accedere a questa pagina."
    end
  end

  def current_user
    @current_user ||= Utente.find(session[:user_id]) if session[:user_id]
  end
end
