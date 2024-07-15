// per il like
document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector(".thumb-button").closest("form");
    
    form.addEventListener("ajax:success", function(event) {
      const [data, status, xhr] = event.detail;
      const notice = document.getElementById("like-notice");
      notice.innerText = data.message;
    });
  
    form.addEventListener("ajax:error", function(event) {
      const [data, status, xhr] = event.detail;
      const notice = document.getElementById("like-notice");
      notice.innerText = "Si è verificato un errore. Per favore riprova.";
    });
  });
  
  
    //
  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.change-icon').forEach(icon => {
      icon.addEventListener('click', (event) => {
        const review = event.target.getAttribute('data-review');
        const stars = event.target.getAttribute('data-review-star');
        const comment = event.target.getAttribute('data-review-commento');
  
        document.getElementById('reviewId').value = review;
        
        document.getElementById('Rid').value = review;
        console.log(review)
        document.getElementById('new_stars').value = stars;
        document.getElementById('new_comment').value = comment; // Imposta il valore del commento qui
  
        updateStars(stars);
        openModal(); // Passa il commento alla funzione openModal
      });
    });
  
    function openModal(comment) {
      document.getElementById('changeReviewModal').style.display = 'block';
    }
  
    function closeReportModal() {
      document.getElementById('changeReviewModal').style.display = 'none';
    }
  
    function updateStars(stars) {
      const starElements = document.querySelectorAll('#reviewStars .star use');
      starElements.forEach((star, index) => {
        star.setAttribute('xlink:href', index < stars ? '#filled-star' : '#empty-star');
      });
    }
  
    window.onclick = function(event) {
      var modal = document.getElementById('changeReviewModal');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
    document.querySelector('#closeChangeModal').onclick = closeReportModal;
  });
  // Function to handle star rating selection
  function selectNewStar(value) {
    document.querySelectorAll('#changeReviewModal .star use').forEach((use, index) => {
      use.setAttribute('xlink:href', index < value ? '#filled-star' : '#empty-star');
    });
  
    document.getElementById('new_stars').value = value;
  
  }
    // azzero i campi del form delle recensioni
     window.onload = function() {
          var urlParams = new URLSearchParams(window.location.search);
          var dateParam = urlParams.get('date');
          var starsFromParam = urlParams.get('stars_from');
          var starsToParam = urlParams.get('stars_to');
          var orderParam = urlParams.get('order');
  
          // Imposta i valori dei campi in base ai parametri della query string se presenti
          document.getElementById("date").value = dateParam || ""; // Se dateParam è null, usa una stringa vuota
          document.getElementById("stars_from").value = starsFromParam || "1";
          document.getElementById("stars_to").value = starsToParam || "5";
          document.getElementById("order").value = orderParam || "asc";
      };
  
      // Funzione per azzerare i campi del form
      function resetForm() {
          document.getElementById("filterForm").reset(); // Resetta il form
  
          // Imposta la data corrente nel campo "Data"
          document.getElementById("date").valueAsDate = new Date();
  
          // Imposta "0" nei campi "Numero di stelle da" e "Numero di stelle a"
          document.getElementById("stars_from").value = "1";
          document.getElementById("stars_to").value = "5";
  
          // Imposta il valore predefinito "Ascendente" nel campo "Ordine"
          document.getElementById("order").value = "asc";
      }
  //JS modale segnalazione
  document.addEventListener("DOMContentLoaded", function() {
    
    document.querySelectorAll('.report-icon').forEach(icon => {
      icon.addEventListener('click', (event) => {
        const review = event.target.getAttribute('data-review');
  
        document.getElementById('recensione_id').value = review;
  
        openModal();
      });
    });
  
    function openModal() {
      document.getElementById('reportModal').style.display = 'block';
    }
  
    function closeReportModal() {
      document.getElementById('reportModal').style.display = 'none';
    }
  
    window.onclick = function(event) {
      var modal = document.getElementById('reportModal');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
    document.querySelector('#closeReport').onclick = closeReportModal;
  });
  
  // JS creazione prenotazione
  document.addEventListener('DOMContentLoaded', function() {
    var reservModal = document.getElementById('reservModal');
    var btn = document.querySelector('.open-reserv-modal');
    var span = document.getElementsByClassName('close-reserv-modal')[0];
  
    btn.onclick = function() {
      reservModal.style.display = 'block';
    }
  
    span.onclick = function() {
      reservModal.style.display = 'none';
    }
  
    window.onclick = function(event) {
      if (event.target == reservModal) {
        reservModal.style.display = 'none';
      }
    }
  
    document.getElementById('reservForm').addEventListener('submit', function(event) {
      event.preventDefault();
  
  
      var num_persone = document.getElementById('num_persone').value;
      var data = document.getElementById('data').value;
      var orario = document.getElementById('orario').value;
      var ristoratore_id = document.getElementById('ristoratore_id').value;
  
      console.log("persone", num_persone);
      console.log("data", data);
      console.log("orario", orario);
      console.log("id rist", ristoratore_id);
  
      fetch('/prenotazione', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          prenotazione: {
            numero_persone: num_persone,
            data: data,
            orario: orario,
            ristoratore_id: ristoratore_id
  
          }
        })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('Prenotazione effettuata con successo!');
        } else {
          alert('Errore durante la prenotazione. Riprova.');
        }
        reservModal.style.display = 'none';
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Errore durante la prenotazione. Riprova.');
        reservModal.style.display = 'none';
      });
    });
  });
  
  // JS recensioni
  function selectStar(value) {
    // Resetta tutte le stelle
    document.querySelectorAll('.star use').forEach(use => {
      use.setAttribute('xlink:href', '#empty-star');
    });
  
    // Imposta le stelle fino al valore cliccato
    for (let i = 1; i <= value; i++) {
      document.querySelector(`.star:nth-child(${i}) use`).setAttribute('xlink:href', '#filled-star');
    }
  
    // Aggiorna il valore nascosto per inviarlo al server
    document.getElementById('stars').value = value;
  }
  
  document.addEventListener("DOMContentLoaded", function() {
    function openModal() {
      document.getElementById('reviewModal').style.display = 'block';
    }
  
    function closeModal() {
      document.getElementById('reviewModal').style.display = 'none';
    }
  
    window.onclick = function(event) {
      var modal = document.getElementById('reviewModal');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
  
    document.querySelector('.review').onclick = openModal;
    document.querySelector('.close').onclick = closeModal;
  });
  
  //Ristorante ai preferiti
  document.addEventListener('DOMContentLoaded', () => {
    const addToFavButton = document.getElementById('add-rest-to-fav');
  
    if (addToFavButton) {
      addToFavButton.addEventListener('click', () => {
        const ristoratoreId = addToFavButton.getAttribute('data-ristoratore-id');
  
        fetch('/add_rest_to_favorites', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ ristoratore_id: ristoratoreId })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            alert('Ristorante aggiunto ai preferiti con successo!');
          } else {
            alert(`Errore: ${data.error}`);
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Si è verificato un errore. Riprova.');
        });
      });
    }
  });
  
  
  
    document.getElementById('add-recipe-fav').addEventListener('click', function(event) {
      event.preventDefault();
      
      const recipeId = this.getAttribute('data-recipe-id');
      
      fetch('/add_recipe_to_favorites', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        credentials: 'same-origin',
        body: JSON.stringify({ recipe_id: recipeId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('Ricetta aggiunta ai preferiti!');
        } else {
          alert('Errore: ' + data.error);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Si è verificato un errore durante l\'aggiunta della ricetta ai preferiti.');
      });
    });
  