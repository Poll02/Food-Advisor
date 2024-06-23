# app/controllers/settings_controller.rb
class SettingsController < ApplicationController
  layout 'with_sidebar'

  def show
    @setting = Setting.first_or_initialize
  end

  def edit
    @setting = Setting.first_or_initialize
  end

  def update
    @setting = Setting.first_or_initialize
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Impostazioni aggiornate con successo.'
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:font, :font_size, :theme)
  end
end
