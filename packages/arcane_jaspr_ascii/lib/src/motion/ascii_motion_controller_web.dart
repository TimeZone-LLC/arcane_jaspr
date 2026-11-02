import 'dart:js_interop';

import 'package:jaspr/client.dart';
import 'package:web/web.dart' as web;

class AsciiMotionController {
  final bool _reveal;
  bool _animated;
  bool _visible = false;
  bool _entered = false;
  bool _disposed = false;
  web.Element? _element;
  web.IntersectionObserver? _intersection;
  web.MutationObserver? _attributes;
  final web.MediaQueryList _preference = web.window.matchMedia(
    '(prefers-reduced-motion: reduce)',
  );
  late final JSFunction _change;
  late final JSFunction _focus;

  AsciiMotionController(
    BuildContext context, {
    required bool animated,
    bool reveal = false,
  }) : _animated = animated,
       _reveal = reveal {
    void findElement(Element element) {
      if (_element != null) return;
      if (element case RenderObjectElement(
        renderObject: final DomRenderElement render,
      )) {
        _element = render.node;
      } else {
        element.visitChildElements(findElement);
      }
    }

    context.visitChildElements(findElement);
    final web.Element? element = _element;
    if (element == null) return;
    _change = ((web.Event event) => _sync()).toJS;
    _focus = ((web.Event event) {
      if (_reveal) {
        _entered = true;
        element.setAttribute('data-ascii-reveal', 'complete');
      }
    }).toJS;
    _preference.addEventListener('change', _change);
    web.document.addEventListener('visibilitychange', _change);
    element.addEventListener('focusin', _focus);
    _attributes = web.MutationObserver(
      ((JSArray<web.MutationRecord> records, web.MutationObserver observer) =>
              _sync())
          .toJS,
    );
    for (
      web.Element? ancestor = element;
      ancestor != null;
      ancestor = ancestor.parentElement
    ) {
      _attributes!.observe(
        ancestor,
        web.MutationObserverInit(
          attributes: true,
          attributeFilter: <JSString>['data-ascii-motion'.toJS].toJS,
        ),
      );
    }
    final web.DOMRect bounds = element.getBoundingClientRect();
    _visible =
        bounds.bottom > 0 &&
        bounds.top < web.window.innerHeight &&
        bounds.right > 0 &&
        bounds.left < web.window.innerWidth;
    _intersection = web.IntersectionObserver(
      ((
            JSArray<web.IntersectionObserverEntry> entries,
            web.IntersectionObserver observer,
          ) {
            if (_disposed) return;
            for (final web.IntersectionObserverEntry entry in entries.toDart) {
              _visible = entry.isIntersecting;
            }
            _sync();
          })
          .toJS,
    );
    _intersection!.observe(element);
    _sync();
  }

  void update({required bool animated}) {
    _animated = animated;
    _sync();
  }

  Map<String, String> get attributes {
    final Map<String, String> attributes = <String, String>{};
    for (final String name in const <String>[
      'data-ascii-motion-state',
      'data-ascii-reveal',
    ]) {
      final String? value = _element?.getAttribute(name);
      if (value != null) attributes[name] = value;
    }
    return attributes;
  }

  void _sync() {
    final web.Element? element = _element;
    if (_disposed || element == null) return;
    final bool permitted =
        _animated &&
        !_preference.matches &&
        element.closest('[data-ascii-motion="off"]') == null;
    final bool running = permitted && _visible && !web.document.hidden;
    element.setAttribute(
      'data-ascii-motion-state',
      running ? 'running' : 'paused',
    );
    if (!_reveal) return;
    if (!permitted) {
      _entered = true;
      element.setAttribute('data-ascii-reveal', 'complete');
    } else if (!_entered) {
      if (running) {
        _entered = true;
        element.setAttribute('data-ascii-reveal', 'entered');
      } else {
        element.setAttribute('data-ascii-reveal', 'waiting');
      }
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _intersection?.disconnect();
    _attributes?.disconnect();
    if (_element != null) {
      _preference.removeEventListener('change', _change);
      web.document.removeEventListener('visibilitychange', _change);
      _element!.removeEventListener('focusin', _focus);
    }
  }
}
