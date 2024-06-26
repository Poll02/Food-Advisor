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

Category.destroy_all
Dish.destroy_all

primi = Category.create(name: 'PRIMI')
secondi = Category.create(name: 'SECONDI')

primi.dishes.create([
  { name: 'Tagliatelle', price: 8.00, ingredients: 'pasta, ragu' },
  { name: 'Ravioli', price: 9.00, ingredients: 'pasta, ricotta, spinaci' }
])

secondi.dishes.create([
  { name: 'Bistecca', price: 15.00, ingredients: 'manzo, olio, sale' },
  { name: 'Pollo', price: 12.00, ingredients: 'pollo, limone, rosmarino' }
])

puts "Database seeded with categories and dishes."

# Trova il ristorante con id 3
ristorante = Ristoratori.find_by(id: 3)

if ristorante
  # Crea le promozioni
  promozione1 = ristorante.promotions.create!(
    data_inizio: Date.today,
    data_fine: Date.tomorrow,
    condizioni: "Sconto del 20% su tutti i piatti",
    tipo: "Sconto"
  )

  promozione2 = ristorante.promotions.create!(
    data_inizio: Date.today + 1,
    data_fine: Date.today + 7,
    condizioni: "Menu fisso a prezzo scontato",
    tipo: "Menu Fisso"
  )

  puts "Promozioni create per il ristorante"
else
  puts "Ristorante con id 3 non trovato"
end


