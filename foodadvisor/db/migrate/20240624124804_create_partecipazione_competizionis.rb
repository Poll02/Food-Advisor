class CreatePartecipazioneCompetizionis < ActiveRecord::Migration[6.1]
  def change
    create_table :partecipazione_competizionis do |t|
      t.integer :idutente
      t.integer :idcomp
      t.references :user, foreign_key: true, null: false
      t.references :competizione, foreign_key: true, null: false

      t.timestamps
    end
  end
end
