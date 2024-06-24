class CreatePartecipazioneCompetizionis < ActiveRecord::Migration[6.1]
  def change
    create_table :partecipazione_competizionis do |t|
      t.integer "idutente"
      t.integer "idcomp"
      t.references :user, foreign_key: true
      t.references :competizione, foreign_key: true
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end
  end
end
