class UserMailer < ApplicationMailer  
    def send_notification
      @notification = params[:notification]
      mail(to: @notification.email, subject: 'Nuova Notifica')
    end
  end
  