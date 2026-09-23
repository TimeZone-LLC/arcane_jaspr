import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:jaspr_test/server_test.dart';

Future<String> _renderText(ServerTester tester, Text text) async {
  tester.pumpComponent(text);
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

void main() {
  testServer('Text uses numeric Flutter typography and semantic heading tags', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text.heading(
        'Account settings',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xff123456),
          height: 1.4,
          letterSpacing: -0.5,
          wordSpacing: 2,
        ),
      ),
    );

    expect(html, contains('<h2 class="arcane-text"'));
    expect(html, contains('font-size: 24.0px'));
    expect(html, contains('font-weight: 500'));
    expect(html, contains('color: rgba(18, 52, 86, 1.00)'));
    expect(html, contains('line-height: 1.4'));
    expect(html, contains('letter-spacing: -0.5px'));
    expect(html, contains('word-spacing: 2.0px'));
    expect(html, contains('text-align: center'));
  });

  testServer('Text keeps raw CSS styling separate from TextStyle', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text(
        'CSS override',
        style: TextStyle(fontSize: 20),
        cssStyle: ArcaneStyleData(fontSize: FontSize.sm),
      ),
    );
    expect(html, contains('font-size: 0.875rem'));
    expect(html, isNot(contains('font-size: 20.0px')));
  });

  testServer('single-line text truncates within the parent width', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text(
        'Long single-line label',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    expect(html, contains('display: inline-block'));
    expect(html, contains('max-width: 100%'));
    expect(html, contains('white-space: nowrap'));
    expect(html, contains('overflow: hidden'));
    expect(html, contains('text-overflow: ellipsis'));
    expect(html, isNot(contains('-webkit-line-clamp')));
  });

  testServer('multi-line clipping honors widget overflow over style', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text(
        'Two lines of text',
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.clip,
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
    expect(html, contains('max-height: 2lh'));
    expect(html, isNot(contains('-webkit-line-clamp')));
    expect(html, contains('white-space: normal'));
    expect(html, contains('text-overflow: clip'));
  });

  testServer('multi-line ellipsis uses line clamping', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text(
        'Two lines of text',
        maxLines: 2,
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
    expect(html, contains('-webkit-line-clamp: 2'));
    expect(html, contains('overflow: hidden'));
  });

  for (final int maxLines in <int>[1, 2]) {
    testServer('visible overflow remains visible with $maxLines lines', (
      ServerTester tester,
    ) async {
      final String html = await _renderText(
        tester,
        Text(
          'Text may overflow',
          maxLines: maxLines,
          style: const TextStyle(overflow: TextOverflow.visible),
        ),
      );
      expect(html, contains('overflow: visible'));
      expect(html, contains('text-overflow: clip'));
      expect(html, isNot(contains('text-overflow: visible')));
      expect(html, isNot(contains('-webkit-line-clamp')));
    });
  }

  testServer('TextStyle can reset inherited and semantic typography', (
    ServerTester tester,
  ) async {
    final String html = await _renderText(
      tester,
      const Text.heading('Plain heading', style: TextStyle(inherit: false)),
    );
    expect(html, contains('<h2 class="arcane-text"'));
    expect(html, contains('font-size: initial'));
    expect(html, contains('font-weight: initial'));
    expect(html, contains('color: initial'));
  });

  test('TextStyle merge preserves unspecified values and honors inherit', () {
    const TextStyle base = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xff123456),
    );
    final TextStyle merged = base.merge(const TextStyle(fontSize: 20));
    expect(merged.fontSize, 20);
    expect(merged.fontWeight, FontWeight.bold);
    expect(merged.color, base.color);
    expect(base.merge(null), same(base));

    const TextStyle detached = TextStyle(inherit: false, fontSize: 12);
    expect(base.merge(detached), same(detached));
    expect(detached.merge(base).inherit, isFalse);
    expect(base.copyWith(height: 1.5).fontSize, 16);
    expect(base.copyWith(height: 1.5).height, 1.5);
  });

  test('TextStyle quotes custom font names and keeps fallback order', () {
    const TextStyle style = TextStyle(
      fontFamily: 'A "Quoted" Font',
      fontFamilyFallback: <String>['Second Font', 'Third Font'],
      height: 0,
    );
    expect(
      style.toMap()['font-family'],
      r'"A \"Quoted\" Font", "Second Font", "Third Font"',
    );
    expect(style.toMap()['line-height'], 'normal');
  });

  test('Text exposes its string with Flutter data naming', () {
    expect(const Text('Content').data, 'Content');
    expect(() => Text('Invalid', maxLines: 0), throwsAssertionError);
  });
}
