# app/models/assign_star.rb
class AssignStar < ApplicationRecord
  belongs_to :cliente
  belongs_to :recensione

  validates :cliente_id, uniqueness: { scope: :recensione_id, message: "Cliente ha già assegnato un like a questa recensione" }
end
