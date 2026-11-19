library;

const String runtimeOtpJs = r'''
function otpContext(target) {
  if (!target || !target.matches || !target.matches('input[data-otp-index]')) return null;
  const root = target.closest('[data-arcane-otp]');
  if (!root || root.getAttribute('data-disabled') === 'true' || target.disabled) return null;
  const inputs = Array.from(root.querySelectorAll('input[data-otp-index]'));
  return { inputs: inputs, index: inputs.indexOf(target) };
}

function focusOtpDigit(inputs, index) {
  const input = inputs[Math.max(0, Math.min(index, inputs.length - 1))];
  if (!input || input.disabled) return;
  input.focus();
  input.select();
}

function bindOtpInputs() {
  document.addEventListener('input', function(event) {
    const context = otpContext(event.target);
    if (!context || event.isComposing) return;
    const input = event.target;
    const digits = input.value.replace(/[^0-9]/g, '');
    // The hydrated callback needs the whole edit after the DOM slots are split.
    event._arcaneOtpValue = digits;
    let next = context.index;
    if (digits.length > 1) {
      const start = digits.length >= context.inputs.length ? 0 : context.index;
      for (let i = start; i < context.inputs.length; i++) {
        context.inputs[i].value = digits[i - start] || '';
      }
      next = start + digits.length;
    } else {
      input.value = digits;
      if (digits) next++;
    }
    context.inputs.forEach(function(digit) {
      digit.classList.toggle('filled', !!digit.value);
      digit.setAttribute('data-state', digit.value ? 'filled' : 'empty');
    });
    if (digits) focusOtpDigit(context.inputs, next);
  }, true);

  document.addEventListener('keydown', function(event) {
    const context = otpContext(event.target);
    if (!context || event.isComposing || event.ctrlKey || event.metaKey || event.altKey) return;
    let next = context.index;
    if (event.key === 'ArrowLeft' || (event.key === 'Backspace' && !event.target.value)) next--;
    else if (event.key === 'ArrowRight') next++;
    else return;
    event.preventDefault();
    focusOtpDigit(context.inputs, next);
  }, true);

  document.addEventListener('paste', function(event) {
    const context = otpContext(event.target);
    if (!context || !event.clipboardData) return;
    event.preventDefault();
    const digits = event.clipboardData.getData('text').replace(/[^0-9]/g, '');
    if (!digits) return;
    event.target.value = digits;
    event.target.dispatchEvent(new InputEvent('input', {
      bubbles: true, inputType: 'insertFromPaste', data: digits
    }));
  }, true);

  document.addEventListener('focusin', function(event) {
    if (otpContext(event.target)) event.target.select();
  }, true);
}
''';
