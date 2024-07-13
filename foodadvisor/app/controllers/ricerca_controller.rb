class RicercaController < ApplicationController
  def index
    @ristoratori = Ristoratore.includes(cliente: :utente)
    @tags = Tag.all

    if params[:query].present?
      @ristoratori = @ristoratori.where('nomeristorante LIKE ?', "%#{params[:query]}%")
    end

    if params[:min_reviews].present? || params[:max_reviews].present?
      min_reviews = params[:min_reviews].present? ? params[:min_reviews].to_i : 0
      max_reviews = params[:max_reviews].present? ? params[:max_reviews].to_i : Float::INFINITY
      @ristoratori = @ristoratori
                      .joins(:recensiones)
                      .group('ristoratores.id')
                      .having('COUNT(recensiones.id) BETWEEN ? AND ?', min_reviews, max_reviews)
    end

    if params[:asporto].present? && params[:asporto] == "1"
      @ristoratori = @ristoratori.where(asporto: true)
    end

    if params[:tags].present?
      tag_ids = params[:tags].map(&:to_i)
      @ristoratori = @ristoratori
                      .joins(:chooses)
                      .where(chooses: { tag_id: tag_ids })
                      .group('ristoratores.id')
                      .having('COUNT(DISTINCT chooses.tag_id) = ?', tag_ids.size)
                      .distinct
    end

    @ristoratori = @ristoratori.limit(10) unless params[:query].present? || params[:min_reviews].present? || params[:max_reviews].present?
  end

  def map_info
    ristoratore = Ristoratore.find(params[:id])
    render json: { name: ristoratore.format_restaurant_name }
  end
end
