require 'rails_helper'

RSpec.feature "RicercaRistoranti", type: :feature do
  background do
    # Creare alcuni tag di esempio
    @italian_tag = Tag.create(nome: "italiano")
    @pizza_tag = Tag.create(nome: "pizza")
    @japanese_tag = Tag.create(nome: "giapponese")
    @sushi_tag = Tag.create(nome: "sushi")

    # Creare alcuni ristoranti di esempio con tag e recensioni
    @utente1 = Utente.create!(email: "ristorante1@gmail.com", telefono: "7543456789", password: "Password1", password_confirmation: "Password1")
    @utente2 = Utente.create!(email: "ristorante2@gmail.com", telefono: "3425467897", password: "Password2", password_confirmation: "Password2")
    @utente3 = Utente.create!(email: "user@gmail.com", telefono: "3425557897", password: "Password3", password_confirmation: "Password3")
    
    # Creazione dei due clienti associati ai due utenti
    @cliente1 = Cliente.create!(utente: @utente1)
    @cliente2 = Cliente.create!(utente: @utente2)
    @cliente3 = Cliente.create!(utente: @utente3)
    
    # Creazione dei due ristoratori associati ai due clienti
    @ristoratore1 = Ristoratore.create!(nomeristorante: "Ristorante A", asporto: true, cliente: @cliente1, piva: "12345678901", indirizzo: "via roma 73")
    @ristoratore2 = Ristoratore.create!(nomeristorante: "Ristorante B", asporto: false, cliente: @cliente2, piva: "09876543212", indirizzo: "via livorno 73")

    @ristoratore1.tags << [@italian_tag, @pizza_tag]
    @ristoratore2.tags << [@japanese_tag, @sushi_tag]

    Recensione.create!(ristoratore: @ristoratore1, cliente: @cliente3, stelle: 4, commento: "ottimo ristorante")
    Recensione.create!(ristoratore: @ristoratore1, cliente: @cliente3, stelle: 4, commento: "ottimo servizio")
    Recensione.create!(ristoratore: @ristoratore2, cliente: @cliente3, stelle: 5, commento: "lo consiglio a tutti")
  end

  scenario "Ricerca di ristoranti per nome" do
    visit ricerca_path
    fill_in "query", with: "Ristorante A"
    find('#cerca').click  # 2) Simula il clic sull'icona dei filtri  
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per tag" do
    visit ricerca_path  # 1) Visita la pagina di ricerca  
    find('#filter-icon').click  # 2) Simula il clic sull'icona dei filtri  
    expect(page).to have_css('#dialog', visible: :visible)  # 3) Verifica che si sia aperta la finestra di dialogo  
    find('button[data-tag-id="1"]').click  # 4) Clicca sul tag italiano  
    click_button "Applica filtri"  # 5) Clicca su Applica filtri  
    expect(page).to have_content("Ristorante A")  # Verifica che il ristorante A sia presente
    expect(page).not_to have_content("Ristorante B")  # Verifica che il ristorante B non sia presente
  end
  

  scenario "Ricerca di ristoranti per media di stelle" do
    visit ricerca_path
    find('#filter-icon').click  # Simula il clic sull'icona dei filtri
    expect(page).to have_css('#dialog', visible: true)
    find('span.star[data-value="5"]').click  # Seleziona le 4 stelle
    click_button "apply-filters"
    expect(page).to have_content("Ristorante B")
    expect(page).not_to have_content("Ristorante A")
  end

  scenario "Ricerca di ristoranti per numero di recensioni" do
    visit ricerca_path
    find('#filter-icon').click  # Simula il clic sull'icona dei filtri
    fill_in "min-reviews", with: "2"
    fill_in "max-reviews", with: "2"
    click_button "Applica filtri"
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per asporto" do
    visit ricerca_path
    find('#filter-icon').click  # Simula il clic sull'icona dei filtri
    expect(page).to have_css('#dialog', visible: true)
    check "asporto"
    click_button "apply-filters"
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per filtri multipli" do
    visit ricerca_path
    find('#filter-icon').click  # Simula il clic sull'icona dei filtri
    find('button[data-tag-id="1"]').click  # Seleziona il tag italiano
    find('span.star[data-value="4"]').click  # Seleziona le 4 stelle
    check "asporto"
    click_button "Applica filtri"
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Annullamento dei filtri" do
    # Visita la pagina di ricerca
    visit ricerca_path
    find('#filter-icon').click
    find('button[data-tag-id="1"]').click
    click_button "Azzera i filtri"
    click_button "Applica filtri"
    expect(page).to have_content("Ristorante A")
    expect(page).to have_content("Ristorante B")
  end
end
