class ProblemsController < ApplicationController

    def new
      @problem = Problem.new
    end

    def create
      @problem = current_user.cliente.user.problems.build(problem_params)
      if @problem.save
        redirect_to supporto_path, notice: 'Segnalazione inviata con successo'
      else
        render 'supporto/index'
      end
    end

    private

    def problem_params
      params.require(:problem).permit(:text)
    end



  end
