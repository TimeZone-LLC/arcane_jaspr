/// Radio button interactivity scripts.
class RadioScripts {
  RadioScripts._();

  static const String code = r'''
  function bindRadioButtons() {
    document.querySelectorAll('.arcane-radio-group').forEach(function(group) {
      if (group.hasAttribute('data-arcane-group')) return;
      if (group.dataset.arcaneInteractive === 'true') return;
      group.dataset.arcaneInteractive = 'true';

      var radios = group.querySelectorAll('.arcane-radio-item, .arcane-radio-card, .arcane-radio-button, .arcane-radio');

      radios.forEach(function(radio) {
        var input = radio.querySelector('input[type="radio"]');
        if (!input || input.disabled) return;

        radio.addEventListener('click', function(e) {
          if (e.target === input) return;
          e.preventDefault();

          input.checked = true;
          input.dispatchEvent(new Event('change', { bubbles: true }));

          radios.forEach(function(r) {
            var rInput = r.querySelector('input[type="radio"]');
            var isChecked = rInput && rInput.checked;

            var circle = r.querySelector('.arcane-radio-circle');
            if (circle) {
              circle.style.borderColor = isChecked ? 'var(--arcane-accent)' : 'var(--arcane-border)';
              var dot = circle.querySelector('div');
              if (isChecked && !dot) {
                dot = document.createElement('div');
                dot.style.cssText = 'width: 10px; height: 10px; border-radius: 50%; background: var(--arcane-accent);';
                circle.appendChild(dot);
              } else if (!isChecked && dot) {
                dot.remove();
              }
            }

            if (r.classList.contains('arcane-radio-card')) {
              r.style.borderColor = isChecked ? 'var(--arcane-accent)' : 'var(--arcane-border)';
              r.style.borderWidth = isChecked ? '2px' : '1px';
              r.style.background = isChecked ? 'var(--arcane-accent-container)' : 'var(--arcane-surface)';
            }

            if (r.classList.contains('arcane-radio-button')) {
              r.style.background = isChecked ? 'var(--arcane-accent)' : 'var(--arcane-surface)';
              r.style.color = isChecked ? 'var(--arcane-accent-foreground)' : 'var(--arcane-on-surface)';
              r.style.borderColor = isChecked ? 'var(--arcane-accent)' : 'var(--arcane-border)';
            }

            var indicator = r.querySelector('.arcane-radio-indicator');
            if (indicator) {
              indicator.style.borderColor = isChecked ? 'var(--arcane-accent)' : 'var(--arcane-border)';
              if (isChecked) {
                indicator.innerHTML = '<div data-arcane-intrinsic-shape="radio-dot" style="width: 10px; height: 10px; border-radius: 50%; background: var(--arcane-accent);"></div>';
              } else {
                indicator.innerHTML = '';
              }
            }
          });
        });
      });
    });
  }
''';
}
