class SupportoController < ApplicationController
  
    def index
      @problem = Problem.new
    end
  
    def create_problem
      @problem = @current_user.problems.build(problem_params)
      if @problem.save
        redirect_to supporto_path, notice: 'Segnalazione inviata con successo.'
      else
        render :index
      end
    end
  
    private
  
    def problem_params
      params.require(:problem).permit(:text)
    end
  
  end
  