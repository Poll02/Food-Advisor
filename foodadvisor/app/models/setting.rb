class Setting < ApplicationRecord
    # Validations, associations, etc.
    validates :font, presence: true
    validates :font_size, presence: true
    validates :theme, presence: true
  
    after_initialize :set_defaults, if: :new_record?
  
    private
  
    def set_defaults
      self.font ||= "Arial"
      self.font_size ||= "medium"
      self.theme ||= "day"
    end
  end