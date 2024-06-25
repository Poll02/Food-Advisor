
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
          document.getElementById('right-side-button').setAttribute('data-competizione-id', id);
          document.getElementById('right-side-nome').innerText = nome;
          document.getElementById('right-side-descrizione').innerText = descrizione;
          document.getElementById('right-side-requisiti').innerText = requisiti;
          document.getElementById('right-side-premio').innerText = premio;
          document.getElementById('right-side-image').src = '/assets/' + locandina; // Assumendo che le immagini siano nella cartella assets
          document.getElementById('right-side-start-data').innerText = dataI;
          document.getElementById('right-side-end-date').innerText = dataF;



        });
      }
      );
      
    });
