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
  });