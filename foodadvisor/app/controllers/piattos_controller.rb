class PiattosController < ApplicationController
    layout 'with_sidebar'
  
    before_action :set_menu
    before_action :set_piatto, only: [:destroy]
  
    def new
      @piatto = @menu.piattos.build
    end
  
    def create
      @piatto = @menu.piattos.build(piattos_params)
  
      if params[:piatto][:foto].present?
        photo_path = save_locandina(params[:piatto][:foto])
        @piatto.foto = photo_path
      end
  
      if @piatto.save
        redirect_to edit_menus_path(@menu), notice: "Piatto aggiunto con successo"
      else
        render :new
      end
    end
  
    def destroy
      @piatto.destroy
      redirect_to edit_menus_path(@menu), notice: 'Piatto eliminato con successo'
    end
  
    private
  
    def set_menu
      @menu = @current_user.cliente.ristoratore.menu
    end
  
    def set_piatto
      @piatto = Piatto.find(params[:id])
    end
  
    def piattos_params
      params.require(:piatto).permit(:nome, :categoria, :prezzo, :ingredienti, :foto)
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
      # Restituisce il percorso relativo dell'immagine
      filename
    end
  end
  