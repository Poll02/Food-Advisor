class Setting < ApplicationRecord
    belongs_to :utente

    def self.default_settings 
      {
      font: 'Poppins',
      font_size: 'medium',
      theme: 'day'
      }
    end
  end
  