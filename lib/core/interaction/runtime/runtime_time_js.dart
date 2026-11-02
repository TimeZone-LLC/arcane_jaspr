library;

const String runtimeTimeJs = r'''
function bindTimePickers() {
  if (!ARCANE._timePopupBound) {
    ARCANE._timePopupBound = true;
    document.addEventListener('arcane:open', function(event) {
      const popup = event.target;
      if (!popup.matches || !popup.matches('[data-arcane-time-popup]')) return;
      const columns = popup.querySelectorAll('[data-arcane-time-column]');
      for (const column of columns) {
        const selected = column.querySelector('[aria-pressed="true"]');
        if (!selected) continue;
        column.scrollTop = selected.offsetTop -
          (column.clientHeight - selected.offsetHeight) / 2;
      }
    });
  }
  const pickers = document.querySelectorAll('[data-arcane-time-picker]');
  for (let i = 0; i < pickers.length; i++) {
    const picker = pickers[i];
    if (picker.__arcaneTimeBound) continue;
    picker.__arcaneTimeBound = true;
    const pickerId = picker.getAttribute('data-arcane-time-picker');
    const use24 = picker.getAttribute('data-arcane-time-24h') === 'true';
    const clearable = picker.getAttribute('data-arcane-time-clearable') === 'true';
    const placeholder = picker.getAttribute('data-arcane-time-placeholder') || 'Select time...';
    const hourGroup = pickerId + '-hour';
    const minuteGroup = pickerId + '-minute';
    const periodGroup = pickerId + '-period';
    function updateDisplay() {
      const hourSet = ARCANE.groups.values(hourGroup);
      const minuteSet = ARCANE.groups.values(minuteGroup);
      const periodSet = ARCANE.groups.values(periodGroup);
      const hour = hourSet.length > 0 ? hourSet[0] : null;
      const minute = minuteSet.length > 0 ? minuteSet[0] : null;
      const period = periodSet.length > 0 ? periodSet[0] : null;
      const display = picker.querySelector('[data-arcane-time-display]');
      if (!display) return;
      if (hour === null && minute === null) {
        display.textContent = placeholder;
        picker.removeAttribute('data-arcane-time-value');
        return;
      }
      const h = hour !== null ? parseInt(hour, 10) : 0;
      const m = minute !== null ? parseInt(minute, 10) : 0;
      const pad = function(n) { return n < 10 ? '0' + n : '' + n; };
      let text;
      if (use24) {
        text = pad(h) + ':' + pad(m);
      } else {
        const p = period === 'pm' ? 'PM' : 'AM';
        text = pad(h) + ':' + pad(m) + ' ' + p;
      }
      display.textContent = text;
      picker.setAttribute('data-arcane-time-value', text);
      fireEvent(picker, 'arcane:change', {
        id: pickerId, hour: h, minute: m, period: period, text: text
      });
    }
    document.addEventListener('arcane:change', function(ev) {
      const detail = ev.detail || {};
      if (detail.groupId === hourGroup || detail.groupId === minuteGroup || detail.groupId === periodGroup) {
        updateDisplay();
      }
    });
    const clear = picker.querySelector('[data-arcane-time-clear]');
    if (clear && clearable) {
      clear.addEventListener('click', function(ev) {
        ev.preventDefault();
        ev.stopPropagation();
        ARCANE.groups.clear(hourGroup);
        ARCANE.groups.clear(minuteGroup);
        ARCANE.groups.clear(periodGroup);
        updateDisplay();
      });
    }
    updateDisplay();
  }
}

ARCANE.timePicker = {
  bind: bindTimePickers
};
''';
