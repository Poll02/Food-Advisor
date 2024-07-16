// JS per aprire la finestra degli eventi
document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("myModal");
    var btn = document.getElementById("add-event-btn");
    var span = document.getElementsByClassName("close")[0];
    var resetBtn = document.getElementById("resetBtn");
    var eventDateField = document.getElementById("eventDate");

    // Imposta la data minima per il campo data
    var today = new Date();
    today.setDate(today.getDate() + 1); // Aggiungi un giorno alla data odierna
    var minDate = today.toISOString().split('T')[0];
    eventDateField.setAttribute('min', minDate);

    btn.onclick = function() {
      modal.style.display = "block";
    }

    span.onclick = function() {
      modal.style.display = "none";
    }

    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }

    resetBtn.onclick = function() {
      var form = modal.querySelector("form");
      form.reset();
    }

  
  });


  // JS per aprire la finestra delle promozioni
  document.addEventListener("DOMContentLoaded", function() {
    var modal2 = document.getElementById("myModal2");
    var btn = document.getElementById("add-promo-btn");
    var span = document.getElementById("close-promo-modal");
    var resetBtn = document.getElementById("resetBtnPromo");
    var eventDateField = document.getElementById("eventDatePromo");

    // Imposta la data minima per il campo data
    var today = new Date();
    today.setDate(today.getDate() + 1); // Aggiungi un giorno alla data odierna
    var minDate = today.toISOString().split('T')[0];
    eventDateField.setAttribute('min', minDate);

    btn.onclick = function() {
      modal2.style.display = "block";
    }

    span.onclick = function() {
      modal2.style.display = "none";
    }

    window.onclick = function(event) {
      if (event.target == modal2) {
        modal2.style.display = "none";
      }
    }

    resetBtn.onclick = function() {
      var form = modal2.querySelector("form");
      form.reset();
    }
  });

  // JS per aprire la finestra delle ricette
  document.addEventListener("DOMContentLoaded", function() {
    var modal = document.getElementById("myModal3");
    var btn = document.getElementById("add-recipe-btn");
    var span = document.getElementById("close-recipe-modal");
    var resetBtn = document.getElementById("resetBtnRecipe");

    btn.onclick = function() {
      modal.style.display = "block";
    }

    span.onclick = function() {
      modal.style.display = "none";
    }

    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }

    resetBtn.onclick = function() {
      var form = modal.querySelector("form");
      form.reset();
    }

  
  });

  // JS per eliminazione evento
  var confirmModal = document.getElementById("confirmModal");
  var closeConfirmBtn = document.getElementsByClassName("close-confirm")[0];
  var confirmDeleteBtn = document.getElementById("confirmDeleteBtn");
  var cancelDeleteBtn = document.getElementById("cancelDeleteBtn");
  var eventIdToDelete = null;

  document.querySelectorAll('.delete-icon').forEach(function(deleteIcon) {
    deleteIcon.onclick = function() {
      eventIdToDelete = this.getAttribute('data-event-id');
      confirmModal.style.display = "block";
    }
  });

  closeConfirmBtn.onclick = function() {
    confirmModal.style.display = "none";
  }

  cancelDeleteBtn.onclick = function() {
    confirmModal.style.display = "none";
    eventIdToDelete = null;
  }

  window.onclick = function(event) {
    if (event.target == confirmModal) {
      confirmModal.style.display = "none";
      eventIdToDelete = null;
    }
  }

  confirmDeleteBtn.onclick = function() {
    if (eventIdToDelete) {
      fetch(`/restaurateur_profiles/destroy_event/${eventIdToDelete}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Content-Type': 'application/json'
        }
      }).then(response => response.json())
        .then(data => {
          if (data.success) {
            document.getElementById(`evento-${eventIdToDelete}`).remove();
            confirmModal.style.display = "none";
          } else {
            alert('Errore durante l\'eliminazione dell\'evento: ' + data.error);
          }
        }).catch(error => {
          alert('Errore durante l\'eliminazione dell\'evento: ' + error.message);
        });
    }
  }

  // JS per eliminazione promozioni
  var confirmPromoModal = document.getElementById("confirmModalPromo");
  var closePromoConfirmBtn = document.getElementsByClassName("close-confirm-promo")[0];
  var confirmPromoDeleteBtn = document.getElementById("confirmDeleteBtnPromo");
  var cancelPromoDeleteBtn = document.getElementById("cancelDeleteBtnPromo");
  var promoIdToDelete = null;

  document.querySelectorAll('.del-promo-icon').forEach(function(deletePromoIcon) {
    deletePromoIcon.onclick = function() {
      promoIdToDelete = this.getAttribute('data-promotion-id');
      console.log("Promo ID to delete:", promoIdToDelete); // Log per verificare ID della promozione da eliminare
      confirmPromoModal.style.display = "block";
    }
  });

  closePromoConfirmBtn.onclick = function() {
    console.log("Close button clicked");
    confirmPromoModal.style.display = "none";
  }

  cancelPromoDeleteBtn.onclick = function() {
    console.log("Cancel delete button clicked");
    confirmPromoModal.style.display = "none";
    promoIdToDelete = null;
  }

  window.onclick = function(event) {
    if (event.target == confirmPromoModal) {
      console.log("Clicked outside modal");
      confirmPromoModal.style.display = "none";
      promoIdToDelete = null;
    }
  }

  confirmPromoDeleteBtn.onclick = function() {
    console.log("Confirm delete button clicked");
    if (promoIdToDelete) {
      fetch(`/restaurateur_profiles/destroy_promotion/${promoIdToDelete}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Content-Type': 'application/json'
        }
      }).then(response => response.json())
        .then(data => {
          console.log("Response from server:", data); // Log per verificare la risposta dal server
          if (data.success) {
            console.log("Promotion deleted successfully");
            document.getElementById(`promotion-${promoIdToDelete}`).remove();
            confirmPromoModal.style.display = "none";
          } else {
            console.error('Errore durante l\'eliminazione della promozione data: ' + data.error);
            alert('Errore durante l\'eliminazione della promozione data: ' + data.error);
          }
        }).catch(error => {
          console.error('Errore durante l\'eliminazione della promozione errore: ' + error.message);
          alert('Errore durante l\'eliminazione della promozione errore: ' + error.message);
        });
    } else {
      console.error("Promo ID to delete is null or undefined");
      alert("Errore: ID promozione da eliminare non valido.");
    }
  }

  // JS per eliminazione ricette
var confirmRecipeModal = document.getElementById("confirmModalRecipe");
var closeRecipeConfirmBtn = document.getElementsByClassName("close-confirm-recipe")[0];
var confirmRecipeDeleteBtn = document.getElementById("confirmDeleteBtnRecipe");
var cancelRecipeDeleteBtn = document.getElementById("cancelDeleteBtnRecipe");
var recipeIdToDelete = null;

document.querySelectorAll('.delete-recipe-icon').forEach(function(deleteRecipeIcon) {
  deleteRecipeIcon.onclick = function() {
    recipeIdToDelete = this.getAttribute('data-recipe-id');
    console.log("Recipe ID to delete:", recipeIdToDelete); // Log per verificare ID della ricetta da eliminare
    confirmRecipeModal.style.display = "block";
  }
});

closeRecipeConfirmBtn.onclick = function() {
  console.log("Close button clicked");
  confirmRecipeModal.style.display = "none";
}

cancelRecipeDeleteBtn.onclick = function() {
  console.log("Cancel delete button clicked");
  confirmRecipeModal.style.display = "none";
  recipeIdToDelete = null;
}

window.onclick = function(event) {
  if (event.target == confirmRecipeModal) {
    console.log("Clicked outside modal");
    confirmRecipeModal.style.display = "none";
    recipeIdToDelete = null;
  }
}

confirmRecipeDeleteBtn.onclick = function() {
  console.log("Confirm delete button clicked");
  if (recipeIdToDelete) {
    fetch(`/restaurateur_profiles/destroy_recipe/${recipeIdToDelete}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json'
      }
    }).then(response => response.json())
      .then(data => {
        console.log("Response from server:", data); // Log per verificare la risposta dal server
        if (data.success) {
          console.log("Recipe deleted successfully");
          document.getElementById(`recipe-${recipeIdToDelete}`).remove();
          confirmRecipeModal.style.display = "none";
        } else {
          console.error('Errore durante l\'eliminazione della ricetta data: ' + data.error);
          alert('Errore durante l\'eliminazione della ricetta data: ' + data.error);
        }
      }).catch(error => {
        console.error('Errore durante l\'eliminazione della ricetta errore: ' + error.message);
        alert('Errore durante l\'eliminazione della ricetta errore: ' + error.message);
      });
  } else {
    console.error("Recipe ID to delete is null or undefined");
    alert("Errore: ID ricetta da eliminare non valido.");
  }
}

