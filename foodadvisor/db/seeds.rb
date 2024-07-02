# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Creare un utente generico

# Creazione degli Utenti
utente1 = Utente.create(email: 'utente1@example.com', password: 'password1', telefono: '1234567890')
utente2 = Utente.create(email: 'utente2@example.com', password: 'password2', telefono: '0987654321')
utente3 = Utente.create(email: 'utente3@example.com', password: 'password3', telefono: '1112223333')

# Creazione di Clienti
cliente1 = Cliente.create(utente: utente1, foto: 'foto1.jpg', dataiscrizione: '2023-01-01')
cliente2 = Cliente.create(utente: utente2, foto: 'foto2.jpg', dataiscrizione: '2023-02-01')
# Creazione di Admin
admin1 = Admin.create(utente: utente3, nome: 'Admin', cognome: 'One')
# Creazione di Ristoratori
ristoratore1 = Ristoratore.create(cliente: cliente1, piva: '12345678901', asporto: true, nomeristorante: 'Ristorante Uno', indirizzo: 'Via Uno, 1')
ristoratore2 = Ristoratore.create(cliente: cliente2, piva: '09876543210', asporto: false, nomeristorante: 'Ristorante Due', indirizzo: 'Via Due, 2')
# Creazione di Users
user1 = User.create(cliente: cliente1, username: 'user1', nome: 'Nome1', cognome: 'Cognome1', datanascita: '1990-01-01')
user2 = User.create(cliente: cliente2, username: 'user2', nome: 'Nome2', cognome: 'Cognome2', datanascita: '1992-02-02')
# Creazione di Critici
critico1 = Critico.create(user: user1, certificato: 'Certificato1')

#creazione di tag
Tag.create(nome: 'Italian', categoria: 'Cuisine')
Tag.create(nome: 'Fast Food', categoria: 'Cuisine')
Tag.create(nome: 'Vegetarian', categoria: 'Diet')
Tag.create(nome: 'Gluten-Free', categoria: 'Diet')
Tag.create(nome: 'Spicy', categoria: 'Flavor')
Tag.create(nome: 'Sweet', categoria: 'Flavor')

# creazione ricette
# Ricetta 1
Recipe.create!(
  name: "Pasta al pomodoro",
  difficulty: "Facile",
  ingredients: "Pasta, pomodoro, olio d'oliva, aglio",
  procedure: "Cuocere la pasta. In una padella, far rosolare l'aglio nell'olio, aggiungere il pomodoro e condire la pasta.",
  photo: "https://example.com/pasta.jpg",
  ristoratore_id: 1  # Sostituisci con l'ID reale del ristoratore
)
# Ricetta 2
Recipe.create!(
  name: "Tiramisù",
  difficulty: "Media",
  ingredients: "Savoiardi, mascarpone, uova, zucchero, caffè",
  procedure: "Preparare il caffè e ammorbidire i savoiardi. Montare il mascarpone con le uova e lo zucchero, alternare gli strati di savoiardi inzuppati nel caffè e crema di mascarpone.",
  photo: "https://example.com/tiramisu.jpg",
  ristoratore_id: 2  # Sostituisci con l'ID reale del ristoratore
)
# Ricetta 3
Recipe.create!(
  name: "Pizza Margherita",
  difficulty: "Media",
  ingredients: "Farina, lievito, acqua, pomodoro, mozzarella, basilico",
  procedure: "Preparare l'impasto e lasciar lievitare. Stendere l'impasto e condire con pomodoro, mozzarella e basilico. Cuocere in forno.",
  photo: "https://example.com/pizza.jpg",
  ristoratore_id: 1  # Sostituisci con l'ID reale del ristoratore
)

#creazione competizioni
# Competizione 1
Competizione.create!(
  nome: "Concorso di cucina 2024",
  descrizione: "Partecipa al nostro concorso di cucina e mostra le tue abilità culinarie!",
  locandina: "https://example.com/concorso_cucina.jpg",
  requisiti: "Aperto a tutti i chef amatoriali e professionisti",
  premio: "Buoni pasto e visibilità sul nostro sito web",
  tag: "Cucina, Concorso, Chef",
  owner: 2,  # Sostituisci con l'ID reale del proprietario della competizione
  data_inizio: DateTime.new(2024, 8, 1, 12, 0, 0),
  data_fine: DateTime.new(2024, 8, 15, 12, 0, 0),
  ristoratore_id: 1  # Sostituisci con l'ID reale del ristoratore
)

# Competizione 2
Competizione.create!(
  nome: "Festival di cocktail estivi",
  descrizione: "Un festival estivo dedicato ai cocktail più innovativi!",
  locandina: "https://example.com/festival_cocktail.jpg",
  requisiti: "Aperto a tutti gli appassionati di cocktail",
  premio: "Voucher per barman professionisti",
  tag: "Cocktail, Bar, Festival",
  owner: 2,  # Sostituisci con l'ID reale del proprietario della competizione
  data_inizio: DateTime.new(2024, 7, 20, 18, 0, 0),
  data_fine: DateTime.new(2024, 7, 25, 22, 0, 0),
  ristoratore_id: 2  # Sostituisci con l'ID reale del ristoratore
)

# Competizione 3
Competizione.create!(
  nome: "Challenge di pasticceria 2024",
  descrizione: "Metti alla prova le tue abilità in pasticceria!",
  locandina: "https://example.com/challenge_pasticceria.jpg",
  requisiti: "Aperto a tutti gli appassionati di dolci",
  premio: "Corso di pasticceria avanzato",
  tag: "Pasticceria, Dolci, Challenge",
  owner: 3,  # Sostituisci con l'ID reale del proprietario della competizione
  data_inizio: DateTime.new(2024, 9, 1, 10, 0, 0),
  data_fine: DateTime.new(2024, 9, 15, 10, 0, 0),
  ristoratore_id: 2  # Sostituisci con l'ID reale del ristoratore
)

