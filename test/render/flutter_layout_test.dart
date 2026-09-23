import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
  ('win95', Win95Stylesheet()),
];

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet stylesheet,
  Widget child,
) async {
  tester.pumpComponent(
    ArcaneThemeProvider(stylesheet: stylesheet, child: child),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

void main() {
  for (final (String name, ArcaneStylesheet theme) in _themes) {
    for (final Axis direction in Axis.values) {
      testServer('$name Wrap separates item and run spacing for $direction', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          Wrap(
            direction: direction,
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.end,
            reverse: true,
            children: const <Widget>[Text('First'), Text('Second')],
          ),
        );
        expect(html, contains('flex-wrap: wrap'));
        expect(
          html,
          contains(
            direction == Axis.horizontal
                ? 'flex-direction: row-reverse'
                : 'flex-direction: column-reverse',
          ),
        );
        expect(
          html,
          contains(
            direction == Axis.horizontal
                ? 'gap: 6.0px 12.0px'
                : 'gap: 12.0px 6.0px',
          ),
        );
        expect(html, contains('justify-content: space-between'));
        expect(html, contains('align-content: center'));
        expect(html, contains('align-items: flex-end'));
      });
    }

    testServer('$name Flex applies axis, spacing, and Flutter alignment', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        const Flex(
          direction: Axis.vertical,
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Text('First'), Text('Second')],
        ),
      );
      expect(html, contains('flex-direction: column'));
      expect(html, contains('align-items: center'));
      expect(html, contains('height: fit-content'));
      expect(html, contains('gap: 12.0px'));
      expect(html, contains('First'));
      expect(html, contains('Second'));
    });

    testServer('$name SizedBox retains finite height with infinite width', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        const SizedBox(
          width: double.infinity,
          height: 32,
          child: Text('Child'),
        ),
      );
      expect(html, contains('width: 100%'));
      expect(html, contains('height: 32.0px'));
      expect(html, isNot(contains('Infinitypx')));
      expect(html, contains('Child'));
    });

    testServer('$name SizedBox retains finite width with infinite height', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        const SizedBox(width: 48, height: double.infinity),
      );
      expect(html, contains('width: 48.0px'));
      expect(html, contains('height: 100%'));
      expect(html, isNot(contains('Infinitypx')));
    });

    testServer('$name SizedBox.expand preserves its child', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        const SizedBox.expand(child: Text('Expanded child')),
      );
      expect(html, contains('width: 100%'));
      expect(html, contains('height: 100%'));
      expect(html, contains('Expanded child'));
    });
  }

  testServer('Flexible distinguishes natural and tight CSS sizing', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ShadcnStylesheet(),
      const Row(
        children: <Widget>[
          Flexible(flex: 2, child: Text('Natural')),
          Expanded(flex: 3, child: Text('Fill')),
        ],
      ),
    );
    expect(html, contains('flex: 0 2 auto'));
    expect(html, contains('flex: 3'));
  });

  testServer('Positioned uses numeric offsets and independent dimensions', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ShadcnStylesheet(),
      const Stack(
        children: <Widget>[
          Positioned(
            top: -4,
            left: 8,
            width: 120,
            height: 24,
            child: Text('Positioned'),
          ),
          Positioned.fill(top: 12, child: Text('Fill')),
        ],
      ),
    );
    expect(html, contains('top: -4.0px'));
    expect(html, contains('left: 8.0px'));
    expect(html, contains('width: 120.0px'));
    expect(html, contains('height: 24.0px'));
    expect(html, contains('top: 12.0px'));
    expect(html, contains('right: 0.0px'));
  });

  test('Flutter layout constructors accept empty child lists', () {
    expect(const Row().children, isEmpty);
    expect(const Column().children, isEmpty);
    expect(const Stack().children, isEmpty);
    expect(const Wrap().children, isEmpty);
    expect(const Wrap().spacing, 0);
    expect(const Wrap().runSpacing, 0);
    expect(const Column().crossAxisAlignment, CrossAxisAlignment.center);
  });

  test('Positioned rejects conflicting constraints', () {
    expect(
      () => Positioned(left: 1, right: 2, width: 3, child: const Text('Child')),
      throwsAssertionError,
    );
    expect(
      () =>
          Positioned(top: 1, bottom: 2, height: 3, child: const Text('Child')),
      throwsAssertionError,
    );
  });
}
