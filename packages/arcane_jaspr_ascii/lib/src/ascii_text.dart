import 'package:characters/characters.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

enum AsciiTextMotion { decode, typewriter, none }

class AsciiText extends StatelessComponent {
  final String text;
  final AsciiTextMotion motion;
  final Duration duration;
  final Duration delay;
  final bool cursor;
  final String? classes;

  const AsciiText(
    this.text, {
    this.motion = AsciiTextMotion.decode,
    this.duration = const Duration(milliseconds: 900),
    this.delay = Duration.zero,
    this.cursor = false,
    this.classes,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final bool animated =
        motion != AsciiTextMotion.none && duration > Duration.zero;
    if (!animated || text.isEmpty) {
      return dom.span(
        <Component>[Component.text(text)],
        classes: 'ascii-text${classes == null ? '' : ' $classes'}',
        attributes: const <String, String>{'data-motion': 'none'},
      );
    }
    final List<String> letters = text.characters.toList(growable: false);
    final double milliseconds = duration.inMicroseconds / 1000;
    final double characterDuration = milliseconds.clamp(
      0,
      motion == AsciiTextMotion.typewriter ? 1 : 110,
    );
    final double interval = letters.length == 1
        ? 0
        : (milliseconds - characterDuration) / (letters.length - 1);
    final double start = delay.isNegative ? 0 : delay.inMicroseconds / 1000;
    final List<Component> content = <Component>[];
    const String glyphs = '+/=:._';
    for (int index = 0; index < letters.length; index++) {
      content.add(
        dom.span(
          <Component>[
            dom.span(<Component>[
              Component.text(letters[index]),
            ], classes: 'ascii-text-letter'),
          ],
          classes: 'ascii-text-char',
          attributes: <String, String>{
            'data-glyph': glyphs[index % glyphs.length],
          },
          styles: dom.Styles(
            raw: <String, String>{
              '--ascii-char-delay':
                  '${(start + interval * index).toStringAsFixed(2)}ms',
              '--ascii-char-duration':
                  '${characterDuration.toStringAsFixed(2)}ms',
            },
          ),
        ),
      );
    }
    return dom.span(
      <Component>[
        dom.span(
          <Component>[Component.text(text)],
          classes: 'ascii-text-accessible',
          styles: const dom.Styles(
            raw: <String, String>{
              'position': 'absolute',
              'width': '1px',
              'height': '1px',
              'padding': '0',
              'margin': '-1px',
              'overflow': 'hidden',
              'clip-path': 'inset(50%)',
              'white-space': 'nowrap',
              'border': '0',
            },
          ),
        ),
        dom.span(
          content,
          attributes: const <String, String>{'aria-hidden': 'true'},
        ),
        if (cursor)
          dom.span(
            const <Component>[Component.text('_')],
            classes: 'ascii-text-cursor',
            attributes: const <String, String>{'aria-hidden': 'true'},
            styles: dom.Styles(
              raw: <String, String>{
                'animation-delay':
                    '${(start + duration.inMilliseconds).toStringAsFixed(2)}ms',
              },
            ),
          ),
      ],
      classes: 'ascii-text${classes == null ? '' : ' $classes'}',
      attributes: <String, String>{'data-motion': motion.name},
    );
  }
}
