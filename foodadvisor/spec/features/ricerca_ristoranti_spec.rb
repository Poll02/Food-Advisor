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
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    save_and_open_screenshot
    fill_in "query", with: "Ristorante A"
    save_and_open_screenshot
    find('#cerca').click   
    save_and_open_screenshot
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per tag" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path  
    find('#filter-icon').click  
    expect(page).to have_css('#dialog', visible: :visible)  
    find('button[data-tag-id="1"]').click  
    click_button "Applica filtri" 
    expect(page).to have_content("Ristorante A") 
    expect(page).not_to have_content("Ristorante B")  
  end
  

  scenario "Ricerca di ristoranti per media di stelle" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    find('#filter-icon').click  
    expect(page).to have_css('#dialog', visible: true)
    find('span.star[data-value="5"]').click  
    click_button "apply-filters"
    expect(page).to have_content("Ristorante B")
    expect(page).not_to have_content("Ristorante A")
  end

  scenario "Ricerca di ristoranti per numero di recensioni" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    find('#filter-icon').click  
    fill_in "min-reviews", with: "2"
    fill_in "max-reviews", with: "2"
    click_button "Applica filtri"
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per asporto" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    find('#filter-icon').click 
    expect(page).to have_css('#dialog', visible: true)
    check "asporto"
    click_button "apply-filters"
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Ricerca di ristoranti per filtri multipli" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    save_and_open_screenshot
    find('#filter-icon').click  
    find('button[data-tag-id="1"]').click  
    find('span.star[data-value="4"]').click  
    check "asporto"
    save_and_open_screenshot
    click_button "Applica filtri"
    save_and_open_screenshot
    expect(page).to have_content("Ristorante A")
    expect(page).not_to have_content("Ristorante B")
  end

  scenario "Annullamento dei filtri" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    visit ricerca_path
    find('#filter-icon').click
    find('button[data-tag-id="1"]').click
    click_button "Azzera i filtri"
    click_button "Applica filtri"
    expect(page).to have_content("Ristorante A")
    expect(page).to have_content("Ristorante B")
  end
end
