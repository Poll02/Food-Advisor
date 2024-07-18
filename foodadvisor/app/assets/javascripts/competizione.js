document.addEventListener('DOMContentLoaded', function() {
    // Trova tutti gli elementi left-side-comp-box
    var compBoxes = document.querySelectorAll('.left-side-comp-box');

    // Aggiungi un event listener per il clic a ciascun box
    compBoxes.forEach(function(box) {
      box.addEventListener('click', function() {
        // Recupera i dati dal box cliccato
        var id = box.getAttribute('data-id');
        var nome = box.getAttribute('data-nome');
        var descrizione = box.getAttribute('data-descrizione');
        var requisiti = box.getAttribute('data-requisiti');
        var premio = box.getAttribute('data-premio');
        var locandina = box.getAttribute('data-locandina');
        var dataI = box.getAttribute('data-date')
        var dataF = box.getAttribute('data-endate')

        // Aggiorna i contenuti del riquadro destro
        var rightSide = document.getElementById('right-side');
        rightSide.style.display = 'flex';
        document.getElementById('right-side-id').innerText = id;
        document.getElementById('right-side-button').setAttribute('data-competizione-id', id);
        document.getElementById('right-side-nome').innerText = nome;
        document.getElementById('right-side-descrizione').innerText = descrizione;
        document.getElementById('right-side-requisiti').innerText = requisiti;
        document.getElementById('right-side-premio').innerText = premio;
        document.getElementById('right-side-image').src = '/assets/' + locandina; // Assumendo che le immagini siano nella cartella assets
        document.getElementById('right-side-start-data').innerText = dataI;
        document.getElementById('right-side-end-date').innerText = dataF;
      });
    });

    // Funzione per la ricerca delle competizioni
    var findbar = document.getElementById('findbar');
    findbar.addEventListener('input', function() {
      var searchText = findbar.value.toLowerCase();
      compBoxes.forEach(function(box) {
        var nome = box.getAttribute('data-nome').toLowerCase();
        if (nome.includes(searchText)) {
          box.style.display = 'flex';
        } else {
          box.style.display = 'none';
        }
      });
    });

    // Conferma per il pulsante di eliminazione
    document.querySelectorAll('.btn.btn-danger').forEach(function(button) {
      button.addEventListener('click', function(event) {
        var confirmation = confirm('Sei sicuro di voler eliminare questa competizione?');
        if (!confirmation) {
          event.preventDefault();
        }
      });
    });

    // Conferma per il pulsante di assegnazione punti
    document.querySelectorAll('.btn.btn-success-punti').forEach(function(button) {
      button.addEventListener('click', function(event) {
        var confirmation = confirm('Sei sicuro di voler assegnare i punti per questa competizione?');
        if (!confirmation) {
          event.preventDefault();
        }
      });
    });
  });

  // JS per le competizioni
  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.iscriviti-button').forEach(function(button) {
      button.addEventListener('click', function() {
        var competitionId = this.getAttribute('data-competizione-id');

        console.log("id competizione", competitionId)
        fetch(`/competizione/${competitionId}/join`, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin'
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            alert('Partecipazione avvenuta con successo!');
          } else {
            alert('Errore nella partecipazione: ' + data.error);
          }
        });
      });
    });
  });