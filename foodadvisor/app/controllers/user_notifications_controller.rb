class UserNotificationsController < ApplicationController
  layout 'with_sidebar'

  def index
    @notifications = @current_user.cliente.notifications
  end
end
