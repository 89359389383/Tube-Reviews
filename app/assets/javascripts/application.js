document.addEventListener('DOMContentLoaded', function() {
  var links = document.querySelectorAll('a[data-method="delete"]');
  
  links.forEach(function(link) {
    link.addEventListener('click', function(event) {
      event.preventDefault();
      var message = link.getAttribute('data-confirm');
      if (!message || confirm(message)) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = link.href;

        var hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = '_method';
        hiddenInput.value = 'delete';
        form.appendChild(hiddenInput);

        var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        var csrfParam = document.querySelector('meta[name="csrf-param"]').getAttribute('content');

        var csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = csrfParam;
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);

        document.body.appendChild(form);
        form.submit();
      }
    });
  });

  document.querySelectorAll('a[data-method="delete"]').forEach(function(link) {
    link.addEventListener('click', function(event) {
      event.preventDefault();
      const message = link.getAttribute('data-confirm');
      if (!message || confirm(message)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = link.href;

        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = '_method';
        hiddenInput.value = 'delete';
        form.appendChild(hiddenInput);

        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        const csrfParam = document.querySelector('meta[name="csrf-param"]').getAttribute('content');

        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = csrfParam;
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);

        document.body.appendChild(form);
        form.submit();
      }
    });
  });
});
