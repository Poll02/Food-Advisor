class Choose < ApplicationRecord
  belongs_to :ristoratori
  belongs_to :tag

  validates :ristoratori_id, presence: true
  validates :tag_id, presence: true
end
