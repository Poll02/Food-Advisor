class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_global_settings

  private

  def set_global_settings
    @setting = Setting.first_or_initialize
  end
end
