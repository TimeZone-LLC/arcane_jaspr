import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

class AsciiDatum extends StatelessComponent {
  final String label;
  final String? value;
  final bool animated;
  final String? classes;

  const AsciiDatum({
    required this.label,
    this.value,
    this.animated = true,
    this.classes,
    super.key,
  });

  @override
  Component build(BuildContext context) => dom.div(
    <Component>[
      const dom.span(
        <Component>[Component.text('+')],
        classes: 'ascii-datum-mark',
        attributes: <String, String>{'aria-hidden': 'true'},
      ),
      dom.span(<Component>[
        Component.text(label),
      ], classes: 'ascii-datum-label'),
      const dom.span(
        <Component>[],
        classes: 'ascii-datum-rule',
        attributes: <String, String>{'aria-hidden': 'true'},
      ),
      if (value != null)
        dom.span(<Component>[
          Component.text(value!),
        ], classes: 'ascii-datum-value'),
      const dom.span(
        <Component>[Component.text('+')],
        classes: 'ascii-datum-mark',
        attributes: <String, String>{'aria-hidden': 'true'},
      ),
    ],
    classes: 'ascii-datum${classes == null ? '' : ' $classes'}',
    attributes: <String, String>{'data-animated': '$animated'},
  );
}
