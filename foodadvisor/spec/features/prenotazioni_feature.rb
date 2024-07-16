require 'rails_helper'

RSpec.feature "Prenotazioni", type: :feature do
  let!(:utente1) { Utente.create(email: "ristorante1@gmail.com", telefono: "7543456789", password: "Password1", password_confirmation: "Password1") }
  let!(:utente2) { Utente.create(email: "ristorante2@gmail.com", telefono: "3425467897", password: "Password2", password_confirmation: "Password2") }
  let!(:utente3) { Utente.create(email: "user@gmail.com", telefono: "3425557897", password: "Password3", password_confirmation: "Password3") }

  let!(:cliente1) { Cliente.create(utente: utente1) }
  let!(:cliente2) { Cliente.create(utente: utente2) }
  let!(:cliente3) { Cliente.create(utente: utente3) }

  let!(:ristoratore1) { Ristoratore.create(nomeristorante: "Ristorante A", asporto: true, cliente: cliente1, piva: "12345678901", indirizzo: "via roma 73") }
  let!(:ristoratore2) { Ristoratore.create(nomeristorante: "Ristorante B", asporto: false, cliente: cliente2, piva: "09876543212", indirizzo: "via livorno 73") }

  let!(:prenotazione1) { Prenotazione.create(user: utente3, ristoratore: ristoratore1, numero_persone: 2, data: '2024-12-24', orario: '19:00', valida: true) }

  before do
    log_in_as(utente3)
  end

  scenario "Prenotazione effettuata con successo" do
    visit public_rest_profile_path(ristoratore1)
    click_button 'Prenota un Tavolo'
    fill_in 'Numero di Persone', with: 2
    fill_in 'Data', with: '2024-12-25'
    fill_in 'Orario', with: '20:00'
    click_button 'Prenota'

    expect(page).to have_content('Prenotazione effettuata con successo')
  end

  scenario "Campi inseriti non validi" do
    visit public_rest_profile_path(ristoratore1)
    click_button 'Prenota un Tavolo'
    fill_in 'Numero di Persone', with: ''
    fill_in 'Data', with: ''
    fill_in 'Orario', with: ''
    click_button 'Prenota'

    expect(page).to have_content('Errore nei campi inseriti')
  end

  scenario "Prenotazione impossibile da effettuare" do
    visit public_rest_profile_path(ristoratore1)
    click_button 'Prenota un Tavolo'
    
    expect(page).to have_content('Errore nella prenotazione')
  end

  context 'Gestione prenotazioni da parte del ristoratore' do
    before do
      log_in_as(utente1)
      visit ristoratore_info_page_path(ristoratore1)
    end

    scenario 'Accettare una prenotazione' do
      find("##{prenotazione1.id}").click
      click_button 'Accetta'
      
      log_in_as(utente3)
      visit user_profile_path(utente3)
      
      expect(page).to have_content('Stato: accettata')
    end

    scenario 'Rifiutare una prenotazione' do
      find("##{prenotazione1.id}").click
      click_button 'Rifiuta'
      
      log_in_as(utente3)
      visit user_profile_path(utente3)
      
      expect(page).not_to have_content('Stato: accettata')
    end
  end
end
