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
    @problem = Problem.find(params[:id])

    if @problem.update(stato: true)
      flash[:notice] = 'Stato del problema aggiornato con successo'
    else
      flash[:alert] = 'Errore durante l\'aggiornamento dello stato del problema'
    end

    redirect_to admin_profile_path
  end

  private

  def problem_params
    params.require(:problem).permit(:text)
  end
end
