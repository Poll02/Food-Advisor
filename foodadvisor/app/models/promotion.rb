class Promotion < ApplicationRecord
belongs_to :ristoratore, class_name: 'Ristoratori', foreign_key: 'ristoratore_id'

end
