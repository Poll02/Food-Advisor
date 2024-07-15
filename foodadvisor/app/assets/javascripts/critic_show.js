document.addEventListener('DOMContentLoaded', function() {
    const calendario = document.getElementById('calendario');
  
    const monthNames = [
        'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
        'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
  
    const weekdayNames = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  
    let currentMonth = (new Date()).getMonth();
    let currentYear = (new Date()).getFullYear();
    let currentDay = (new Date()).getDate();
  
    // Funzione per creare il calendario
    function createCalendar(month, year, bookings) {
      const firstDay = new Date(year, month, 1).getDay();
      const daysInMonth = new Date(year, month + 1, 0).getDate();
  
      let calendarHTML = '';
  
      // Mese corrente
      calendarHTML += `<div class="month">${monthNames[month]} ${year}</div>`;
  
      // Giorni della settimana
      calendarHTML += '<div class="weekdays">';
      weekdayNames.forEach(day => {
        calendarHTML += `<div class="weekday">${day}</div>`;
      });
      calendarHTML += '</div>';
  
      // Giorni del mese
      calendarHTML += '<div class="days">';
      // Aggiungi celle vuote fino al primo giorno del mese
      for (let i = 0; i < firstDay; i++) {
        calendarHTML += '<div class="day empty"></div>';
      }
  
      // Aggiungi giorni del mese
      for (let day = 1; day <= daysInMonth; day++) {
        const hasBooking = bookings.includes(day);
        calendarHTML += `
          <div class="day" style="cursor: pointer;" onclick="loadDailyData(${day})">
            ${day}
            ${hasBooking ? '<div class="booking-indicator" style="background-color: #ffd166; width: 10px; height: 10px; border-radius: 50%; margin: auto; margin-top: 2px;"></div>' : ''}
          </div>
        `;
      }
      calendarHTML += '</div>';
  
      calendario.innerHTML = calendarHTML;
    }
  
    // Funzione per caricare i dati giornalieri al clic su un giorno
    window.loadDailyData = function(day) {
      fetch(`/daily_bookings?year=${currentYear}&month=${currentMonth + 1}&day=${day}`)
        .then(response => response.json())
        .then(data => {
          // Logica per gestire i dati giornalieri (prenotazioni, eventi)
          console.log('Dati giornalieri:', data);
  
          // Esempio di visualizzazione dei dati nell'interfaccia utente
          const impegniGiornalieri = document.getElementById('impegniGiornalieri');
          impegniGiornalieri.innerHTML = '';
  
          if (data.prenotazioni.length > 0) {
            const prenotazioniSection = document.createElement('div');
            prenotazioniSection.classList.add('section');
            prenotazioniSection.innerHTML = '';
            data.prenotazioni.forEach(prenotazione => {
              const prenotazioneElement = document.createElement('div');
              prenotazioneElement.classList.add('prenotazionetavolo');
              prenotazioneElement.innerHTML = `
                <div style="font-size: 13px; background-color: #ffd166; padding: 1%; border-radius: 10px; ">
                  <p> ID cliente: ${prenotazione.user_id}</p>
                  <p> N persone: ${prenotazione.numero_persone}</p>
                  <p> Orario: ${prenotazione.orario}</p>
                </div>
              `;
              prenotazioniSection.appendChild(prenotazioneElement);
            });
            impegniGiornalieri.appendChild(prenotazioniSection);
          } else {
            impegniGiornalieri.innerHTML = '<p style="color: gray; ">Nessun impegno per questo giorno.</p>';
          }
        })
        .catch(error => console.error('Errore nel caricamento dei dati giornalieri:', error));
    };
  
    // Inizializza il calendario per il mese corrente
    loadMonthlyBookings(currentMonth, currentYear);
  
    // Simula un clic sul giorno corrente
    window.loadDailyData(currentDay);
  
    // Funzione per caricare le prenotazioni del mese
    function loadMonthlyBookings(month, year) {
      fetch(`/monthly_bookings?year=${year}&month=${month + 1}`)
        .then(response => response.json())
        .then(data => {
          const bookings = data.bookings.map(booking => new Date(booking.data).getDate());
          createCalendar(month, year, bookings);
        })
        .catch(error => console.error('Errore nel caricamento delle prenotazioni mensili:', error));
    }
  });