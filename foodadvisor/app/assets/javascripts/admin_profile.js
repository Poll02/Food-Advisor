// per lo stato dei problemi
document.addEventListener('DOMContentLoaded', function() {
    const updateForms = document.querySelectorAll('.update-status-form');
    updateForms.forEach(form => {
      form.addEventListener('submit', function(event) {
        const confirmMessage = this.getAttribute('data-confirm');
        if (!confirm(confirmMessage)) {
          event.preventDefault();
        }
      });
    });

    document.querySelectorAll("tr[data-url]").forEach(function(row) {
      row.addEventListener("click", function(event) {
        // Controlla se l'elemento cliccato ha la classe 'icon-cell' o è un suo discendente
        if (!event.target.closest(".icon-cell")) {
          window.location = row.getAttribute("data-url");
        }
      });
    });
  
    document.querySelectorAll('.fa-clipboard').forEach(icon => {
    icon.addEventListener('click', (event) => {
      const cliente = event.target.getAttribute('data-cliente');
  
      // Imposta l'ID del cliente nel campo nascosto
      document.getElementById('cliente_id').value = cliente;
  
      // Esegui la richiesta AJAX per recuperare le segnalazioni
      fetch(`/segnalazione_index?cliente_id=${cliente}`)
        .then(response => response.json())
        .then(data => {
          let dimensioneArray = data.length;
          // Genera il contenuto HTML delle segnalazioni
          let segnalazioniHTML = '';
          if (dimensioneArray > 0) {
            segnalazioniHTML += `
            <h2>Segnalazioni ricevute (${dimensioneArray})</h2>
            <div id="segnalazioni-container">`;
      
            data.forEach(segnalazione => {
              segnalazioniHTML += `
              <div class="segnalazione">
              <p><strong>ID segnalatore:</strong> ${segnalazione.cliente_id}</p>
                <p><strong>Motivo:</strong> ${segnalazione.motivo}</p>
              </div>`;
            });
  
            segnalazioniHTML += `</div>`;
          } else {
            segnalazioniHTML = `
            <h2>Nessuna segnalazione</h2>`;
          }
          // Inserisce il contenuto HTML nel contenitore delle segnalazioni
          document.getElementById('segnalazioni-container').innerHTML = segnalazioniHTML;
          openClipModal();
        })
        .catch(error => console.error('Errore:', error));
    });
  });
  
  function openClipModal() {
    document.getElementById('clipboardModal').style.display = 'block';
  }
  
  function closeClipboardModal() {
    document.getElementById('clipboardModal').style.display = 'none';
  }
  
  window.onclick = function(event) {
    var modal = document.getElementById('clipboardModal');
    if (event.target == modal) {
      modal.style.display = 'none';
    }
  }
  
  document.querySelector('#closeClipboard').onclick = closeClipboardModal;
  
  
  document.querySelectorAll('.fa-person-circle-check').forEach(icon => {
      icon.addEventListener('click', (event) => {
        const cliente = event.target.getAttribute('data-cliente');
  
        document.getElementById('data_id').value = cliente;
  
  
        openCleanModal();
      });
    });
  
    function openCleanModal() {
      document.getElementById('cleanReportModal').style.display = 'block';
    }
  
    function closeCleanReportModal() {
      document.getElementById('cleanReportModal').style.display = 'none';
    }
  
    window.onclick = function(event) {
      var modal = document.getElementById('cleanReportModal');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
    document.querySelector('#closeCleanReport').onclick = closeCleanReportModal;
  
    document.querySelectorAll('.fa-ban').forEach(icon => {
      icon.addEventListener('click', (event) => {
        const cliente = event.target.getAttribute('data-cliente');
  
        document.getElementById('delete_id').value = cliente;
  
  
        openDeleteModal();
      });
    });
  
    function openDeleteModal() {
      document.getElementById('deleteUserModal').style.display = 'block';
    }
  
    function closeDeleteModal() {
      document.getElementById('deleteUserModal').style.display = 'none';
    }
  
    window.onclick = function(event) {
      var modal = document.getElementById('deleteUserModal');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
    document.querySelector('#closeDeleteUser').onclick = closeDeleteModal;
  });