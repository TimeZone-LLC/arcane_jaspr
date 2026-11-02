import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  testServer('interactive ratings use native non-submit buttons', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      ArcaneThemeProvider(
        stylesheet: const NeubrutalismStylesheet(),
        child: RatingStars(
          rating: 3,
          interactive: true,
          onRatingChanged: (_) {},
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    final List<String> buttons = RegExp(r'<button\b[^>]*>')
        .allMatches(response.body)
        .map((RegExpMatch match) => match.group(0)!)
        .toList();

    expect(buttons, hasLength(5));
    expect(buttons, everyElement(contains('type="button"')));
    expect(buttons[2], contains('aria-label="Rate 3 out of 5"'));
    expect(buttons[2], contains('aria-pressed="true"'));
    expect(buttons[1], contains('aria-pressed="false"'));
  });

  for (final bool interactive in <bool>[false, true]) {
    testServer(
      'rating without callback is static with interactive=$interactive',
      (ServerTester tester) async {
        tester.pumpComponent(
          ArcaneThemeProvider(
            stylesheet: const NeubrutalismStylesheet(),
            child: RatingStars(rating: 3, interactive: interactive),
          ),
        );
        final DocumentResponse response = await tester.request('/');
        expect(response.statusCode, 200);
        expect(response.body, isNot(contains('<button')));
        expect(response.body, contains('aria-label="3 out of 5 stars"'));
        expect(response.body, contains('role="img"'));
      },
    );
  }
}
