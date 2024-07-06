class NotificationsController < ApplicationController
    
    def new
        @notification = Notification.new
      end
    
      def create
        Rails.logger.info("inizio creazione notifica")
        Rails.logger.info(params.inspect) # Aggiungi questo per vedere i parametri nei log
        user = Utente.find_by(email: params[:email])
        if user
          @notification = user.cliente.notifications.new(notification_params)
          if @notification.save
            UserMailer.with(notification: @notification).send_notification.deliver_later
            redirect_to admin_profile_path, notice: 'Notifica inviata con successo!'
          else
            render 'admin_profile/show'
          end
        else
          redirect_to admin_profile_path, alert: 'Utente non trovato!'
        end
      end
      
    
      private
    
      def notification_params
        params.permit(:email, :message)
      end
end
