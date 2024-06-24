class DropPartecipazioneCompetizionis < ActiveRecord::Migration[6.1]
  def change
    drop_table :partecipazione_competizionis

  end
end
