import 'dart:js_interop';

import 'package:web/web.dart' as web;

class MotionObserver {
  final void Function(bool) _onChanged;
  final web.MediaQueryList _preference = web.window.matchMedia(
    '(prefers-reduced-motion: reduce)',
  );
  late final JSFunction _listener;
  late bool _previous;

  MotionObserver(this._onChanged) {
    _previous = canAnimate;
    _listener = _handleChange.toJS;
    _preference.addEventListener('change', _listener);
    web.document.addEventListener('visibilitychange', _listener);
  }

  bool get canAnimate => !_preference.matches && !web.document.hidden;

  void dispose() {
    _preference.removeEventListener('change', _listener);
    web.document.removeEventListener('visibilitychange', _listener);
  }

  void _handleChange(web.Event event) {
    final bool allowed = canAnimate;
    if (allowed == _previous) {
      return;
    }
    _previous = allowed;
    _onChanged(allowed);
  }
}
