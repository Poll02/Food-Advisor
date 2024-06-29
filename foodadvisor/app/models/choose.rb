class Choose < ApplicationRecord
  self.primary_key = :ristoratori_id, :tag_id

  belongs_to :ristoratori, foreign_key: :ristoratori_id
  belongs_to :tag, foreign_key: :tag_id
end
