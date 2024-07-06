class ProblemsController < ApplicationController
  def create
    @problem = Problem.new(problem_params)
    @problem.cliente_id = @current_user.cliente.id

    if @problem.save
      redirect_to supporto_path, notice: 'Segnalazione inviata con successo'
    else
      redirect_to supporto_path, alert: 'Segnalazione non inviata'
    end
  end

  def aggiorna_stato_problema
    @problem = Problem.find(params[:id]) # Assume che il parametro :id sia passato come parte della richiesta PUT
    
    if @problem.update(stato: true)
      render json: { status: 'success', message: 'Stato del problema aggiornato con successo' }
    else
      render json: { status: 'error', message: 'Errore durante l\'aggiornamento dello stato del problema' }, status: :unprocessable_entity
    end
  end

  private

  def problem_params
    params.require(:problem).permit(:text)
  end
end
