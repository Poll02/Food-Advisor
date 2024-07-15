document.addEventListener('DOMContentLoaded', function() {
    const filterMenuIcon = document.getElementById('filter-menu-icon');
    const dialog = document.getElementById('dialog');
    const closeButton = document.querySelector('.close-button');
    const applyFiltersButton = document.getElementById('apply-filters');
    const resetFiltersButton = document.getElementById('reset-filters');

    // Aprire la finestra modale al clic sull'icona
    filterMenuIcon.addEventListener('click', function(event) {
        const iconRect = filterMenuIcon.getBoundingClientRect();
        dialog.style.top = `${iconRect.bottom}px`;
        dialog.style.left = `${iconRect.left}px`;
        dialog.style.display = 'block';

        // Prepopolare i campi del modulo con i valori attuali dei parametri URL
        const params = new URLSearchParams(window.location.search);
        document.getElementById('categoria').value = params.get('categoria') || '';
        document.getElementById('prezzoMin').value = params.get('prezzoMin') || '';
        document.getElementById('prezzoMax').value = params.get('prezzoMax') || '';
        document.getElementById('ingredienti').value = params.get('ingredienti') || '';
    });

    // Chiudere la finestra modale al clic sul pulsante di chiusura
    closeButton.addEventListener('click', function() {
        dialog.style.display = 'none';
    });

    // Applicare i filtri al clic sul pulsante "Applica filtri"
    applyFiltersButton.addEventListener('click', function() {
        // Recuperare i valori dei filtri
        const query = document.getElementById('findbar').value;
        const categoria = document.getElementById('categoria').value;
        const prezzoMin = document.getElementById('prezzoMin').value;
        const prezzoMax = document.getElementById('prezzoMax').value;
        const ingredienti = document.getElementById('ingredienti').value;

        // Eseguire la ricerca con i filtri
        const url = buildUrlWithFilters(query, categoria, prezzoMin, prezzoMax, ingredienti);
        window.location.href = url; // Esempio di come potresti gestire la navigazione verso la pagina di ricerca
    });

    // Azzerare i filtri al clic sul pulsante "Azzera filtri"
    resetFiltersButton.addEventListener('click', function() {
        document.getElementById('categoria').value = '';
        document.getElementById('prezzoMin').value = '';
        document.getElementById('prezzoMax').value = '';
        document.getElementById('ingredienti').value = '';

        // Eseguire la ricerca senza filtri
        const query = document.getElementById('findbar').value;
        const url = buildUrlWithFilters(query, '', '', '', '');
        window.location.href = url;
    });

    // Funzione per costruire l'URL con i parametri dei filtri
    function buildUrlWithFilters(query, categoria, prezzoMin, prezzoMax, ingredienti) {
        let url = window.location.pathname; // Ottiene l'URL corrente
        let params = new URLSearchParams(window.location.search);

        // Aggiorna i parametri dell'URL
        if (query) {
            params.set('query', query);
        } else {
            params.delete('query');
        }

        if (categoria) {
            params.set('categoria', categoria);
        } else {
            params.delete('categoria');
        }

        if (prezzoMin) {
            params.set('prezzoMin', prezzoMin);
        } else {
            params.delete('prezzoMin');
        }

        if (prezzoMax) {
            params.set('prezzoMax', prezzoMax);
        } else {
            params.delete('prezzoMax');
        }

        if (ingredienti) {
            params.set('ingredienti', ingredienti);
        } else {
            params.delete('ingredienti');
        }

        return `${url}?${params.toString()}`;
    }
});
