class RicercaController < ApplicationController
  def index
    @ristoratori = Ristoratore.includes(cliente: :utente)
    @tags = Tag.all

    if params[:query].present?
      @ristoratori = @ristoratori.where('nomeristorante LIKE ?', "%#{params[:query]}%")
    end

    if params[:min_reviews].present? || params[:max_reviews].present?
      min_reviews = params[:min_reviews].present? ? params[:min_reviews].to_i : 0
      max_reviews = params[:max_reviews].present? ? params[:max_reviews].to_i : nil
      @ristoratori = @ristoratori
                      .joins(:recensiones)
                      .group('ristoratores.id')
      if max_reviews
        @ristoratori = @ristoratori.having('COUNT(recensiones.id) >= ? AND COUNT(recensiones.id) <= ?', min_reviews, max_reviews)
      else
        @ristoratori = @ristoratori.having('COUNT(recensiones.id) >= ?', min_reviews)
      end    
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

    # Applicare il filtro delle stelle come ultimo passo, dopo aver applicato i filtri SQL
    if params[:star_rating].present?
      @ristoratori = @ristoratori.select { |r| r.media_stelle >= params[:star_rating].to_f }
    end

    @ristoratori = @ristoratori.first(10) unless params[:query].present? || params[:min_reviews].present? || params[:max_reviews].present?

    Rails.logger.info("filtro stelle applicato #{@ristoratori}")

  end

  def map_info
    ristoratore = Ristoratore.find(params[:id])
    render json: { name: ristoratore.format_restaurant_name }
  end
end
