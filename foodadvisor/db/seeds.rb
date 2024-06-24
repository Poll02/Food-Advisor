# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.first 

Competizione.create!(
  nome: "Competizione di Test",
  descrizione: "Questa è una prima competizione di esempio per testare la creazione di record.",
  locandina: "background.jpg",
  requisiti: "Nessun requisito specifico.",
  premio: "Un premio non simbolico.",
  tag: "esempio, test",
  owner: user,
  data_inizio: DateTime.now,
  data_fine: DateTime.now + 1.month
)
