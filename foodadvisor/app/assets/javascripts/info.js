
// JS PER IL GRAFICO
document.addEventListener('DOMContentLoaded', function() {
    // Ottieni la data corrente
    var currentDate = new Date();
  
    // Calcola il lunedì della settimana corrente
    var currentDay = currentDate.getDay();
    var distanceToMonday = currentDay === 0 ? 6 : currentDay - 1;
    var mondayDate = new Date(currentDate);
    mondayDate.setDate(currentDate.getDate() - distanceToMonday);
  
    // Converte la data in stringa 'YYYY-MM-DD'
    var startDate = mondayDate.toISOString().split('T')[0];
  
    fetch(`/bookings_per_week?start_date=${startDate}`)
      .then(response => response.json())
      .then(data => {
        // Definisci i giorni della settimana e inizializza i dati a zero
        const daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        const orderedBookingData = daysOfWeek.map(day => {
          const date = new Date(startDate);
          date.setDate(date.getDate() + daysOfWeek.indexOf(day));
          const dateString = date.toISOString().split('T')[0];
          return data.bookings[dateString] || 0;
        });
  
        const orderedReviewData = daysOfWeek.map(day => {
          const date = new Date(startDate);
          date.setDate(date.getDate() + daysOfWeek.indexOf(day));
          const dateString = date.toISOString().split('T')[0];
          return data.reviews[dateString] || 0;
        });
  
        var ctx = document.getElementById('graficoSettimana').getContext('2d');
        var graficoSettimana = new Chart(ctx, {
          type: 'line',
          data: {
            labels: daysOfWeek,
            datasets: [{
              label: 'Numero di Prenotazioni',
              data: orderedBookingData,
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              borderColor: 'rgba(75, 192, 192, 1)',
              borderWidth: 1
            }, {
              label: 'Numero di Recensioni',
              data: orderedReviewData,
              backgroundColor: 'rgba(255, 99, 132, 0.2)',
              borderColor: 'rgba(255, 99, 132, 1)',
              borderWidth: 1
            }]
          },
          options: {
            scales: {
              y: {
                beginAtZero: true,
                ticks: {
                  callback: function(value) {
                    if (Number.isInteger(value)) {
                      return value;
                    }
                  },
                  stepSize: 1
                }
              }
            }
          }
        });
      });
  });
  
  
  // JS PER IL CALENDARIO
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
    function createCalendar(month, year) {
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
        calendarHTML += `<div class="day" style="cursor: pointer; " onclick="loadDailyData(${day})">${day}</div>`;
      }
      calendarHTML += '</div>';
  
      calendario.innerHTML = calendarHTML;
    }
  
    // Funzione per caricare i dati giornalieri al clic su un giorno
    window.loadDailyData = function(day) {
      fetch(`/daily_bookings_and_events?year=${currentYear}&month=${currentMonth + 1}&day=${day}`)
        .then(response => response.json())
        .then(data => {
          // Logica per gestire i dati giornalieri (prenotazioni, eventi)
          console.log('Dati giornalieri:', data);
  
          // Esempio di visualizzazione dei dati nell interfaccia utente
          const impegniGiornalieri = document.getElementById('impegniGiornalieri');
          impegniGiornalieri.innerHTML = '';
          
          function formatTime(orario) {
            const date = new Date(orario);
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            return `${hours-1}:${minutes}`;
          }

          if (data.prenotazioni.length > 0 || data.eventi.length > 0) {
            if (data.prenotazioni.length > 0) {
              const prenotazioniSection = document.createElement('div');
              prenotazioniSection.classList.add('section');
              prenotazioniSection.innerHTML = '';
              data.prenotazioni.forEach(prenotazione => {
                const prenotazioneElement = document.createElement('div');
                prenotazioneElement.classList.add('prenotazionetavolo');
                const formattedTime = formatTime(prenotazione.orario);
                prenotazioneElement.innerHTML = `
                  <div style="font-size: 13px; background-color: #ffd166; padding: 1%; border-radius: 10px; ">
                    <p> ID cliente: ${prenotazione.user_id}</p>
                    <p> N persone: ${prenotazione.numero_persone}</p>
                    <p> Orario: ${formattedTime}</p>
                  </div>
                `;
                prenotazioniSection.appendChild(prenotazioneElement);
              });
              impegniGiornalieri.appendChild(prenotazioniSection);
            }
  
            if (data.eventi.length > 0) {
              const eventiSection = document.createElement('div');
              eventiSection.classList.add('section');
              eventiSection.innerHTML = '';
              data.eventi.forEach(evento => {
                const eventoElement = document.createElement('div');
                eventoElement.classList.add('evento');
                eventoElement.innerHTML = `
                  <div style="font-size: 13px; background-color: #dde5b6; padding: 1%; border-radius: 10px; ">
                    <p> Nome: ${evento.nome}</p>
                    <p> Luogo: ${evento.luogo}</p>
                    <p> Descrizione: ${evento.descrizione}</p>
                  </div>
                `;
                eventiSection.appendChild(eventoElement);
              });
              impegniGiornalieri.appendChild(eventiSection);
            }
          } else {
            impegniGiornalieri.innerHTML = '<p style="color: gray; ">Nessun impegno per questo giorno.</p>';
          }
        })
        .catch(error => console.error('Errore nel caricamento dei dati giornalieri:', error));
    };
  
    // Inizializza il calendario per il mese corrente
    createCalendar(currentMonth, currentYear);
  
    // Simula un clic sul giorno corrente
    window.loadDailyData(currentDay);
  });
  
    // JS per la validazione delle prenotazioni
    
  
    // per i dipendenti
    document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.remove-dipendente').forEach(function(button) {
      button.addEventListener('click', function() {
        var dipendenteId = this.getAttribute('data-dip-id');
        if (confirm('Sei sicuro di voler eliminare questo dipendente?')) {
          fetch('/info/destroy_dipendente/' + dipendenteId, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
          })
          .then(response => response.json())
          .then(data => {
            if (data.success) {
              alert('Dipendente eliminato con successo.');
              document.getElementById('dipendente-' + dipendenteId).remove();
            } else {
              alert('Errore: ' + data.error);
            }
          });
        }
      });
    });
  });
  