import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  testServer('orbit retains semantic children in static server markup', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const AsciiOrbit(
        children: <Component>[
          dom.a(<Component>[Component.text('Read the guide')], href: '/guide'),
        ],
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('href="/guide"'));
    expect(response.body, contains('Read the guide'));
    expect(response.body, contains('ascii-orbit-guides'));
    expect(response.body, contains('aria-hidden="true"'));
    expect(response.body, isNot(contains('data-ascii-motion-state')));
    expect(
      RegExp('aria-hidden="true"').allMatches(response.body),
      hasLength(1),
    );
  });

  testServer('reveal renders visible content before browser enhancement', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const AsciiReveal(
        child: Component.text('Read immediately'),
        delay: Duration(milliseconds: -20),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('Read immediately'));
    expect(response.body, contains('--ascii-reveal-delay: 0ms'));
    expect(response.body, isNot(contains('data-ascii-reveal=')));
    expect(response.body, isNot(contains('opacity: 0')));
    expect(response.body, isNot(contains('aria-hidden')));
  });

  testServer('nonpositive orbit duration disables motion', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(const AsciiOrbit(duration: Duration.zero));
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('data-animated="false"'));
    expect(response.body, isNot(contains('Infinity')));
    expect(response.body, isNot(contains('NaN')));
  });
}
