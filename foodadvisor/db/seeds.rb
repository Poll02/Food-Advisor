require 'faker'

Faker::Config.locale = 'it'

# Genera una password cifrata
password_digest = 'Password123'

# Funzione per copiare le immagini di esempio nella cartella assets/images
def copy_image_to_assets(source, destination)
  source_path = File.join(Rails.root, 'app', 'assets', 'images', source)
  destination_path = File.join(Rails.root, 'app', 'assets', 'images', destination)
  FileUtils.cp(source_path, destination_path)
end

def generate_random_piva
  rand(0..987654321).to_s.rjust(11, '0')
end

# CREAZIONE DATI
# Creiamo 20 utenti, dei quali 18 saranno clienti e 2 admin
20.times do |i|
  if i == 19
    email = 'utente3@example.com'
    password = 'Password3'
  else
    email = Faker::Internet.email
    password = password_digest
  end

  telefono = Faker::PhoneNumber.cell_phone
  facebook_id = Faker::Internet.uuid
  name = Faker::Name.name

  utente = Utente.create!(
    email: email,
    password: password,
    password_confirmation: password,
    telefono: telefono,
    facebook_id: facebook_id,
    name: name
  )

  if i < 19 # primi 19 sono clienti
    Cliente.create!(
      utente_id: utente.id,
      foto: 'default-propic.jpg'
    )
  else # ultimo admin
    Admin.create!(
      utente_id: utente.id,
      nome: Faker::Name.first_name,
      cognome: Faker::Name.last_name
    )
  end
end

ristoratori = Cliente.limit(8).map do |cliente|
  ristoratore = Ristoratore.create!(
    cliente_id: cliente.id,
    piva: generate_random_piva,
    asporto: [true, false].sample,
    nomeristorante: Faker::Restaurant.name,
    indirizzo: Faker::Address.full_address
  )

  # Verifica se il menu è già stato creato (dovrebbe essere evitato)
  if ristoratore.menu.nil?
    menu = Menu.create!(
      ristoratore_id: ristoratore.id
    )
  end

  # Creiamo dipendenti per questo ristoratore
  5.times do
    Dipendente.create!(
      nome: Faker::Name.first_name,
      cognome: Faker::Name.last_name,
      foto: 'user.jpg',
      ruolo: %w[fattorino cameriere cassiere sommelier cuoco lavapiatti direttore\ di\ sala aiuto-chef].sample,
      assunzione: Faker::Date.between(from: '2015-01-01', to: Date.today),
      ristoratore_id: ristoratore.id
    )
  end

  # Creiamo eventi per questo ristoratore
  3.times do
    Evento.create!(
      nome: Faker::Lorem.word,
      data: Faker::Date.between(from: Date.today, to: '2025-12-31'),
      luogo: Faker::Address.full_address,
      descrizione: Faker::Lorem.sentence,
      locandina: 'evento.jpg',
      ristoratore_id: ristoratore.id
    )
  end

  # Trova il menu associato al ristoratore
  menu = Menu.find_by(ristoratore_id: ristoratore.id)
  
  # Creiamo piatti per il menu di questo ristoratore
  categories = ["Antipasto", "Primo", "Secondo", "Dolce", "Bevanda", "Pizza"]
  categories.each do |category|
    5.times do
      foto = case category
            when "Antipasto" then 'antipasto.jpg'
            when "Primo" then 'primo.jpg'
            when "Secondo" then 'secondo.jpg'
            when "Dolce" then 'dolce.jpg'
            when "Bevanda" then 'bevanda.jpg'
            when "Pizza" then 'pizza.jpg'
            else 'piatto.jpg' # Fallback in caso di categoria non prevista
            end

      Piatto.create!(
        menu_id: menu.id,  # Utilizziamo il menu appena creato per questo ristoratore
        nome: Faker::Food.dish,
        prezzo: Faker::Commerce.price(range: 5.0..50.0),
        foto: foto,
        ingredienti: Faker::Food.ingredient,
        categoria: category
      )
    end
  end

  # Creiamo almeno 2 ricette per questo ristoratore
  2.times do
    Recipe.create!(
      name: Faker::Food.dish,
      difficulty: ["Facile", "Medio", "Difficile"].sample,
      ingredients: Faker::Food.ingredient,
      procedure: Faker::Food.description,
      photo: 'recipe.jpg',
      ristoratore_id: ristoratore.id
    )
  end

  # Creiamo 3 competizioni per questo ristoratore
  3.times do
    requisiti = ['nessuno', 'prenotazioni', 'recensioni', 'punti'].sample
    quantitareq = requisiti == 'nessuno' ? 0 : Faker::Number.between(from: 1, to: 10)

    Competizione.create!(
      nome: Faker::Lorem.word,
      locandina: 'background.jpg',
      descrizione: '2 punti: lasciare una recensione\n5 punti: effettuare una prenotazione valida\n3 punti: ricevi un like alla recensione da un critico\n2 punti: ricevi un like alla recensione',
      requisiti: requisiti,
      premio: Faker::Commerce.product_name,
      quantitareq: quantitareq,
      data_inizio: Faker::Date.between(from: '2024-01-01', to: Date.today),
      data_fine: Faker::Date.between(from: Date.today, to: '2025-07-01'),
      ristoratore_id: ristoratore.id
    )
  end

  ristoratore
end


# Creiamo 10 user collegati ai restanti 10 clienti
Cliente.offset(8).limit(11).each do |cliente|
  user = User.create!(
    cliente_id: cliente.id,
    username: Faker::Internet.username,
    nome: Faker::Name.first_name,
    cognome: Faker::Name.last_name,
    datanascita: Faker::Date.birthday(min_age: 18, max_age: 65),
    punti: Faker::Number.between(from: 0, to: 1000)
  )

  # Tra questi 10 user, 3 saranno critici
  if Cliente.offset(8).limit(3).include?(cliente)
    Critico.create!(
      user_id: user.id,
      certificato: 'certificato.jpg'
    )
  end
end

# Creazione dei tag
Tag.create(nome: 'Italian', categoria: 'Cuisine')
Tag.create(nome: 'Fast Food', categoria: 'Cuisine')
Tag.create(nome: 'Vegetarian', categoria: 'Diet')
Tag.create(nome: 'Gluten-Free', categoria: 'Diet')
Tag.create(nome: 'Spicy', categoria: 'Flavor')
Tag.create(nome: 'Sweet', categoria: 'Flavor')
Tag.create(nome: 'Chinese', categoria: 'Cuisine')
Tag.create(nome: 'Mexican', categoria: 'Cuisine')
Tag.create(nome: 'Indian', categoria: 'Cuisine')
Tag.create(nome: 'French', categoria: 'Cuisine')
Tag.create(nome: 'Japanese', categoria: 'Cuisine')
Tag.create(nome: 'Keto', categoria: 'Diet')
Tag.create(nome: 'Low Carb', categoria: 'Diet')
Tag.create(nome: 'High Protein', categoria: 'Diet')
Tag.create(nome: 'Vegan', categoria: 'Diet')
Tag.create(nome: 'Dairy-Free', categoria: 'Diet')
Tag.create(nome: 'Savory', categoria: 'Flavor')
Tag.create(nome: 'Sour', categoria: 'Flavor')
Tag.create(nome: 'Bitter', categoria: 'Flavor')
Tag.create(nome: 'Umami', categoria: 'Flavor')
Tag.create(nome: 'Breakfast', categoria: 'Meal Type')
Tag.create(nome: 'Lunch', categoria: 'Meal Type')
Tag.create(nome: 'Dinner', categoria: 'Meal Type')
Tag.create(nome: 'Snack', categoria: 'Meal Type')
Tag.create(nome: 'Dessert', categoria: 'Meal Type')
Tag.create(nome: 'Appetizer', categoria: 'Meal Type')
Tag.create(nome: 'Healthy', categoria: 'Feature')
Tag.create(nome: 'Quick & Easy', categoria: 'Feature')
Tag.create(nome: 'Comfort Food', categoria: 'Feature')
Tag.create(nome: 'Gourmet', categoria: 'Feature')
Tag.create(nome: 'Kids', categoria: 'Feature')


# Associa i tag ai ristoratori tramite Choose
Tag.all.each do |tag|
  # Ogni tag sarà associato a 3 ristoratori casuali
  ristoratori.sample(3).each do |ristoratore|
    Choose.create!(
      ristoratore_id: ristoratore.id,
      tag_id: tag.id
    )
  end
end

# Gli utenti salvano ristoratori e ricette preferiti
users = User.all
recipes = Recipe.all

users.each do |user|
  # Ogni user salva da 1 a 3 ristoratori preferiti
  ristoratori.sample(rand(1..3)).each do |ristoratore|
    FavRistoranti.create!(
      user_id: user.id,
      ristoratore_id: ristoratore.id
    )
  end

  # Ogni user salva da 1 a 3 ricette preferite
  recipes.sample(rand(1..3)).each do |recipe|
    FavRecipe.create!(
      user_id: user.id,
      recipe_id: recipe.id
    )
  end
end

# Creiamo le istanze di UserCompetition
users.each do |user|
  # Gli user partecipano attualmente a massimo 2 competizioni
  Competizione.where("data_fine > ?", Date.today).sample(2).each do |competizione|
    UserCompetition.create!(
      user_id: user.id,
      competizione_id: competizione.id,
      punti_competizione: Faker::Number.between(from: 0, to: 100)
    )
  end

  # Gli user hanno partecipato a competizioni passate
  Competizione.where("data_fine <= ?", Date.today).sample(rand(1..3)).each do |competizione|
    UserCompetition.create!(
      user_id: user.id,
      competizione_id: competizione.id,
      punti_competizione: Faker::Number.between(from: 0, to: 100)
    )
  end
end

# Creiamo problemi segnalati dai clienti all'admin
Cliente.all.each do |cliente|
  rand(1..3).times do
    Problem.create!(
      cliente_id: cliente.id,
      text: Faker::Lorem.sentence
    )
  end
end

Admin.all.each do |admin|
  Cliente.all.each do |cliente|
    cliente_random = Cliente.all.sample  # Selezione casuale di un cliente

    Notification.create!(
      cliente_id: cliente_random.id,
      email: cliente_random.utente.email,
      message: Faker::Lorem.sentence
    )
  end
end

# Creiamo prenotazioni
User.all.each do |user|
  ristoratori.sample(rand(1..3)).each do |ristoratore|
    data = Faker::Date.between(from: Date.today, to: 5.days.from_now)

    orario = if data == Date.today
               Faker::Time.between(from: Time.now, to: Date.today.end_of_day, format: :short)
             else
               Faker::Time.between(from: data.beginning_of_day, to: data.end_of_day, format: :short)
             end

    Prenotazione.create!(
      user_id: user.id,
      ristoratore_id: ristoratore.id,
      data: data,
      orario: orario,
      numero_persone: Faker::Number.between(from: 1, to: 20)
    )
  end
end

# creazione recensioni
User.all.each do |user|
  cliente = user.cliente # Assume che ci sia un'associazione tra User e Cliente

  next if cliente.nil? # Salta se l'user non è associato a un cliente

  ristoratori.sample(rand(1..3)).each do |ristoratore|
    Recensione.create!(
      cliente_id: cliente.id,
      ristoratore_id: ristoratore.id,
      commento: Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4),
      stelle: Faker::Number.between(from: 1, to: 5),
      created_at: Faker::Date.between(from: 5.days.ago, to: 5.days.from_now)
    )
  end
end

# Creiamo assign_stars per le recensioni
Recensione.all.each do |recensione|
  cliente_random = Cliente.all.sample  # Estrae un cliente casuale

  AssignStar.create!(
    recensione_id: recensione.id,
    cliente_id: cliente_random.id  # Usa l'ID del cliente casuale estratto
  )
end
