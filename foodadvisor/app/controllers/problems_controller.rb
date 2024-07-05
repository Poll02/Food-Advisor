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

  private

  def problem_params
    params.require(:problem).permit(:text)
  end
end
