/// Modal dialog interactivity scripts.
class ModalScripts {
  ModalScripts._();

  static const String code = r'''
  function bindDialogs() {
    document.querySelectorAll('.arcane-dialog-overlay, [role="dialog"]').forEach(function(overlay) {
      if (overlay.closest('[data-arcane-surface]')) return;
      if (overlay.dataset.arcaneInteractive === 'true') return;
      overlay.dataset.arcaneInteractive = 'true';

      var dialog = overlay.querySelector('.arcane-dialog') || overlay;
      var closeBtn = overlay.querySelector('.arcane-dialog-close, [aria-label="Close"]');

      function closeDialog() {
        overlay.style.opacity = '0';
        if (dialog !== overlay) {
          dialog.style.transform = 'scale(0.95)';
        }
        setTimeout(function() {
          overlay.style.display = 'none';
          document.body.style.overflow = '';
        }, 150);
      }

      if (closeBtn) {
        closeBtn.addEventListener('click', closeDialog);
      }

      overlay.addEventListener('click', function(e) {
        if (e.target === overlay) {
          closeDialog();
        }
      });

      document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && overlay.style.display !== 'none') {
          closeDialog();
        }
      });
    });

    document.querySelectorAll('button').forEach(function(btn) {
      var text = (btn.textContent || '').toLowerCase();
      if (text.includes('open dialog') || text.includes('show dialog')) {
        if (btn.dataset.arcaneDialogBound) return;
        btn.dataset.arcaneDialogBound = 'true';

        btn.addEventListener('click', function() {
          var overlay = document.querySelector('.arcane-dialog-overlay');
          if (overlay) {
            document.body.style.overflow = 'hidden';
            overlay.style.display = 'flex';
            overlay.style.opacity = '1';
            var dialog = overlay.querySelector('.arcane-dialog');
            if (dialog) {
              dialog.style.transform = 'scale(1)';
            }
          }
        });
      }
    });
  }
''';
}
