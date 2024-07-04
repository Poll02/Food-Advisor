class ProblemsController < ApplicationController
  
    def create
      @problem = Problem.new(
        text: params[:text],
        cliente_id: @current_user.cliente.id
      )
      
      if @problem.save
        redirect_to supporto_path, notice: 'Segnalazione inviata con successo'
      else
        redirect_to supporto_path, alert: 'Segnalazione non inviata'
      end
    end
  end
