# app/controllers/settings_controller.rb
class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update]
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

  private

  def set_setting
    @setting = Setting.first_or_initialize
  end

  def setting_params
    params.require(:setting).permit(:font, :font_size, :theme)
  end
end
