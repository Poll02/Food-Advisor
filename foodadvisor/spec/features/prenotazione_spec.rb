require 'rails_helper'

RSpec.feature "Booking", type: :feature, js: true do
  let(:utente1) { Utente.create!(email: "ristorante1@gmail.com", telefono: "7543456789", password: "Password1", password_confirmation: "Password1") }
  let(:utente2) { Utente.create!(email: "ristorante2@gmail.com", telefono: "3425467897", password: "Password2", password_confirmation: "Password2") }
  let(:utente3) { Utente.create!(email: "user@gmail.com", telefono: "3425557897", password: "Password3", password_confirmation: "Password3") }

  let(:cliente1) { Cliente.create!(utente: utente1) }
  let(:cliente2) { Cliente.create!(utente: utente2) }
  let(:cliente3) { Cliente.create!(utente: utente3) }
  
  let(:user3) { User.create!(cliente: cliente3, username: "user123", nome: "Nome", cognome: "Cognome", datanascita: "1990-01-01") }

  let(:ristoratore1) { Ristoratore.create!(nomeristorante: "Ristorante A", asporto: true, cliente: cliente1, piva: "12345678901", indirizzo: "via roma 73") }
  let(:ristoratore2) { Ristoratore.create!(nomeristorante: "Ristorante B", asporto: false, cliente: cliente2, piva: "09876543212", indirizzo: "via livorno 73") }


  scenario "Prenotazione effettuata con successo" do
    login_as(user3)
    save_and_open_screenshot
    visit public_restaurant_profile_path(ristoratore1)
    save_and_open_screenshot
    # L'utente clicca su "Prenota un tavolo" per aprire il modal
    find('.open-reserv-modal').click
    save_and_open_screenshot
    
    # Imposta i valori dei campi utilizzando execute_script
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-07-23';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")

    # Esegui uno script JavaScript per impostare l'orario con AM/PM
    #execute_script("document.getElementById('orario').value = '07:00 PM';")
    save_and_open_screenshot


    click_button 'Prenota'
    save_and_open_screenshot

    expect(page).to have_current_path(public_restaurant_profile_path(ristoratore1))
    save_and_open_screenshot
    
    # Aspetta che la risposta AJAX venga gestita e verifica la presenza del messaggio di conferma
    expect(page).to have_content('Prenotazione creata con successo')
    save_and_open_screenshot

    visit user_profile_path
    save_and_open_screenshot

    # Verifica che la prenotazione appena fatta sia presente tra le prenotazioni dell'utente
    expect(page).to have_content('2024-07-23')
    expect(page).to have_content('20:00')
    expect(page).to have_content('4')
    save_and_open_screenshot
  end

  scenario "Campi inseriti non validi" do
    login_as(user3)
    visit public_restaurant_profile_path(ristoratore1)    
    find('.open-reserv-modal').click
    
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-07-03';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")

    click_button 'Prenota'
    expect(page).to have_current_path(public_restaurant_profile_path(ristoratore1))
    
    expect(page).to have_content('Errore nella prenotazione')
  end

  scenario "Prenotazione impossibile da effettuare" do    
    login_as_ristoratore(ristoratore1)
    visit public_restaurant_profile_path(ristoratore1)
    find('.open-reserv-modal').click
    
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-08-03';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")

    click_button 'Prenota'    
    expect(page).to have_content('Non puoi effettuare la prenotazione')
  end

  scenario "Accettare una prenotazione" do
    login_as_ristoratore(ristoratore1)
    booking = Prenotazione.create!(user: user3, ristoratore: ristoratore1, numero_persone: 2, data: Date.tomorrow, orario: '19:00', valida: false)
    
    visit info_path
    find("i.fa-solid.fa-check.check-icon[data-prenotazione-id='#{booking.id}']").click
    
    logout
    login_as(user3)
    
    visit user_profile_path(user3)
    expect(page).to have_content('Accettata')
  end

  scenario "Rifiutare una prenotazione" do
    login_as_ristoratore(ristoratore1)
    booking = Prenotazione.create!(user: user3, ristoratore: ristoratore1, numero_persone: 2, data: Date.tomorrow, orario: '19:00', valida: false)
    
    visit info_path
    click_button 'Rifiuta Prenotazione'
    
    logout
    login_as(user3)
    
    visit user_profile_path(user3)
    expect(page).not_to have_content(booking.data.to_s)
  end
end

def login_as(user)
  visit user_login_path
  save_and_open_screenshot
  fill_in 'session[email]', with: user.cliente.utente.email
  fill_in 'session[password]', with: user.cliente.utente.password
  save_and_open_screenshot
  click_button 'Accedi come utente'
end

def login_as_ristoratore(ristoratore)
  visit restaurateur_login_path
  fill_in 'restaurateur[piva]', with: ristoratore.piva
  fill_in 'restaurateur[password]', with: ristoratore.cliente.utente.password
  click_button 'Accedi'
end

def logout
  visit logout_path
end