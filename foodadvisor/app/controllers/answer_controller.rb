# app/controllers/reviews_controller.rb
class AnswerController < ApplicationController
  before_action :set_recensione, only: [:create]
  before_action :set_answer, only: [:update]
  before_action :set_answer_delete, only: [:destroy]

  def create
    @answer=Answer.new(
        ristoratore: @current_user.cliente.ristoratore,
        risposta: params[:answer]
    )

    @answer.recensione = @recensione

    if @answer.save
        flash[:notice] = 'Risposta salvata con successo!'
        redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    else
        flash[:alert] = 'Errore nel salvataggio della risposta!'
        redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    end
  end

  def update
    if @answer.update(risposta: params[:answer_change])
      flash[:notice] = 'Risposta modificata con successo!'
      redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    else
      flash[:alert] = 'Errore nella modifica della risposta!'
      redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    end
  end

  def destroy
    if @answer.destroy
      flash[:notice] = 'Risposta eliminata con successo!'
      redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    else
      flash[:alert] = 'Errore nella cancellazione della risposta!'
      redirect_to rest_profile_path(@current_user.cliente.ristoratore.id)
    end

  end

  private

  def set_answer
    @answer=Answer.find(params[:answerId])
  end

  def set_answer_delete
    @answer=Answer.find(params[:answerDeleteId])
  end

  def set_recensione
    @recensione=Recensione.find(params[:reviewId])
  end
end
  