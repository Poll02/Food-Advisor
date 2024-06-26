class PromotionsController < ApplicationController
    def index
        @promotions = Promotion.where(ristoratore_id: current_user.id)
    end
  end
  