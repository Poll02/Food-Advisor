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
    page.driver.browser.manage.window.resize_to(1920, 1080)

    login_as(user3)
    visit public_restaurant_profile_path(ristoratore1)
    # L'utente clicca su "Prenota un tavolo" per aprire il modal
    find('.open-reserv-modal').click
    
    # Imposta i valori dei campi utilizzando execute_script
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-07-23';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")

    click_button 'Prenota'

    expect(page).to have_current_path(public_restaurant_profile_path(ristoratore1))
    expect(page).to have_content('Prenotazione creata con successo')

    visit user_profile_path

    # Verifica che la prenotazione appena fatta sia presente tra le prenotazioni dell'utente
    expect(page).to have_content('2024-07-23')
    expect(page).to have_content('20:00')
    expect(page).to have_content('4')
  end

  scenario "Campi inseriti non validi" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

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
    page.driver.browser.manage.window.resize_to(1920, 1080)
  
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
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # per perima cosa creiamo una prenotazione valida
    login_as(user3)
    visit public_restaurant_profile_path(ristoratore1)
    save_and_open_screenshot
    # L'utente clicca su "Prenota un tavolo" per aprire il modal
    find('.open-reserv-modal').click
    # Imposta i valori dei campi utilizzando execute_script
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-07-23';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")
    save_and_open_screenshot
    click_button 'Prenota'
    expect(page).to have_current_path(public_restaurant_profile_path(ristoratore1))
    # Aspetta che la risposta AJAX venga gestita e verifica la presenza del messaggio di conferma
    expect(page).to have_content('Prenotazione creata con successo')
    save_and_open_screenshot

    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click
    save_and_open_screenshot

    # Effettua il logout cliccando sul link 'Logout' nel dropdown
    within '#dropdown' do
      click_link 'Logout'
    end
    save_and_open_screenshot

    # login come ristoratore per validare la prenotazione
    login_as_ristoratore(ristoratore1)
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click
    within '#dropdown' do
      click_link 'Visualizza Profilo'
    end
    
    visit info_path
    save_and_open_screenshot

    # cerco la prenotazione
    all('.prenotazione').each do |prenotazione|
      # Estrai le informazioni di ogni prenotazione
      nome_cliente = prenotazione.find('.pren-info p:nth-child(1) span').text.strip
      numero_persone = prenotazione.find('.pren-info p:nth-child(2) span').text.strip.to_i
      data = prenotazione.find('.pren-info p:nth-child(3) span').text.strip
      orario = prenotazione.find('.pren-info p:nth-child(4) span').text.strip
  
      # Verifica se questa è la prenotazione desiderata
      if nome_cliente == 'Nome Cognome' && data == '2024-07-23' && orario == '20:00' && numero_persone == 4
        # Esempio specifico: se l'ID della prenotazione è 1, sostituisci con:
        find(".check-icon").click

        # Attendi che la richiesta AJAX abbia completato il suo lavoro
        expect(page).to have_content('Prenotazione aggiornata con successo.')
        save_and_open_screenshot

        found_prenotazione = true
        break # Esci dal ciclo una volta trovata la prenotazione
      end
    end

    # per la verifica simuliamo il clic sul calendario e vediamo che in quella giornata c'è la prenotazione
    page.execute_script("loadDailyData('2024-07-23'.split('-')[2]);")
    sleep(2) # Attendiamo un po' per assicurarci che i dati vengano caricati correttamente

    # Verifica che la prenotazione sia presente tra gli impegni giornalieri
    expect(page).to have_content('ID cliente: 1')
    expect(page).to have_content('N persone: 4')
    expect(page).to have_content('Orario: 20:00')
    
    save_and_open_screenshot

    #logout
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click

    # Effettua il logout cliccando sul link 'Logout' nel dropdown
    within '#dropdown' do
      click_link 'Logout'
    end

    # login come user per vedere la validazione accettata
    login_as(user3)
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click
    within '#dropdown' do
      click_link 'Visualizza Profilo'
    end

    #mi aspetto di trovare la prenotazione accettata
    expect(page).to have_content('Accettata')
  end

  scenario "Rifiutare una prenotazione" do
    page.driver.browser.manage.window.resize_to(1920, 1080)

    # per perima cosa creiamo una prenotazione valida
    login_as(user3)
    visit public_restaurant_profile_path(ristoratore1)
    # L'utente clicca su "Prenota un tavolo" per aprire il modal
    find('.open-reserv-modal').click
    # Imposta i valori dei campi utilizzando execute_script
    execute_script("document.getElementById('numero-persone').value = '4';")
    execute_script("document.getElementById('data-prenotazione').value = '2024-07-23';")
    execute_script("document.getElementById('orario-prenotazione').value = '20:00';")
    click_button 'Prenota'
    expect(page).to have_current_path(public_restaurant_profile_path(ristoratore1))
    # Aspetta che la risposta AJAX venga gestita e verifica la presenza del messaggio di conferma
    expect(page).to have_content('Prenotazione creata con successo')

    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click

    # Effettua il logout cliccando sul link 'Logout' nel dropdown
    within '#dropdown' do
      click_link 'Logout'
    end

    # login come ristoratore per validare la prenotazione
    login_as_ristoratore(ristoratore1)
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click
    within '#dropdown' do
      click_link 'Visualizza Profilo'
    end
    visit info_path

    # cerco la prenotazione
    all('.prenotazione').each do |prenotazione|
      # Estrai le informazioni di ogni prenotazione
      nome_cliente = prenotazione.find('.pren-info p:nth-child(1) span').text.strip
      numero_persone = prenotazione.find('.pren-info p:nth-child(2) span').text.strip.to_i
      data = prenotazione.find('.pren-info p:nth-child(3) span').text.strip
      orario = prenotazione.find('.pren-info p:nth-child(4) span').text.strip
  
      # Verifica se questa è la prenotazione desiderata
      if nome_cliente == 'Nome Cognome' && data == '2024-07-23' && orario == '20:00' && numero_persone == 4
        # Esempio specifico: se l'ID della prenotazione è 1, sostituisci con:
        find(".delete-icon").click

        # Attendi che la richiesta AJAX abbia completato il suo lavoro
        expect(page).to have_content('Prenotazione eliminata')

        found_prenotazione = true
        break # Esci dal ciclo una volta trovata la prenotazione
      end
    end

    # per la verifica simuliamo il clic sul calendario e vediamo che in quella giornata c'è la prenotazione
    page.execute_script("loadDailyData('2024-07-23'.split('-')[2]);")
    sleep(2) # Attendiamo un po' per assicurarci che i dati vengano caricati correttamente

    # Verifica che la prenotazione sia presente tra gli impegni giornalieri
    expect(page).not_to have_content('ID cliente: 1')
    expect(page).not_to have_content('N persone: 4')
    expect(page).not_to have_content('Orario: 20:00')

    #logout
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click

    # Effettua il logout cliccando sul link 'Logout' nel dropdown
    within '#dropdown' do
      click_link 'Logout'
    end

    # login come user per vedere la validazione accettata
    login_as(user3)
    # Clicca sull'icona dell'omino nella navbar per aprire il dropdown
    find('ion-icon[name="person-circle-outline"]').click
    within '#dropdown' do
      click_link 'Visualizza Profilo'
    end

    #mi aspetto di trovare la prenotazione accettata
    expect(page).not_to have_content('Ristorante: Ristorante A ')
    expect(page).not_to have_content('Numero Persone: 4')
    expect(page).not_to have_content('Data: 2024-07-23')
    expect(page).not_to have_content('Orario: 20:00')   
  end
end

def login_as(user)
  visit user_login_path
  fill_in 'session[email]', with: user.cliente.utente.email
  fill_in 'session[password]', with: user.cliente.utente.password
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