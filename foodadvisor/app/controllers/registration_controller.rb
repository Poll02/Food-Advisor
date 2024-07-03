class RegistrationController < ApplicationController
  def new
    @utente = Utente.new
    @utente.build_cliente
    @utente.cliente.build_ristoratore
    @utente.cliente.build_user
    @utente.cliente.user.build_critico
  end
  
  def new_user
    @utente = Utente.new
    @utente.build_cliente.build_user
  end

  def new_critico
    @utente = Utente.new
    @utente.build_cliente.build_user.build_critico
  end

  def new_ristoratore
    @utente = Utente.new
    @utente.build_cliente.build_ristoratore
  end

  def create_user
    @utente = Utente.new(user_params)

    if params[:utente][:cliente_attributes][:foto]
      uploaded_file = params[:utente][:cliente_attributes][:foto]
      file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      @utente.cliente.foto = uploaded_file.original_filename
    end
  
    if @utente.save
      redirect_to root_path, notice: "Registrazione utente completata con successo!"
    else
      render :new_user
    end
  end
  

  def create_critico
    @utente = Utente.new(critico_params)
  
    if params[:utente][:cliente_attributes][:foto]
      uploaded_file = params[:utente][:cliente_attributes][:foto]
      file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      @utente.cliente.foto = uploaded_file.original_filename
    end

    if @utente.save
      redirect_to root_path, notice: "Registrazione critico completata con successo!"
    else
      render :new_critico
    end
  end
  

  def create_ristoratore
    @utente = Utente.new(ristoratore_params)
  
    if params[:utente][:cliente_attributes][:foto]
      uploaded_file = params[:utente][:cliente_attributes][:foto]
      file_path = Rails.root.join('app', 'assets', 'images', uploaded_file.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      @utente.cliente.foto = uploaded_file.original_filename
    end

    if @utente.save
      redirect_to root_path, notice: "Registrazione ristoratore completata con successo!"
    else
      render :new_ristoratore
    end
  end
  

  private

  def user_params
    params.require(:utente).permit(:email, :password, :password_confirmation, :telefono,
                                   cliente_attributes: [:id, :foto, :dataiscrizione,
                                                        user_attributes: [:username, :nome, :cognome, :datanascita]])
  end
  
  def critico_params
    params.require(:utente).permit(:email, :password, :password_confirmation, :telefono,
                                   cliente_attributes: [:id, :foto, :dataiscrizione,
                                                        user_attributes: [:username, :nome, :cognome, :datanascita,
                                                                          critico_attributes: [:certificato]]])
  end
  
  def ristoratore_params
    params.require(:utente).permit(:email, :password, :password_confirmation, :telefono,
                                   cliente_attributes: [:id, :foto, :dataiscrizione,
                                                        ristoratore_attributes: [:piva, :asporto, :nomeristorante, :indirizzo]])
  end
  
end
