import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

const List<(String, ArcaneStylesheet, String)> _themes =
    <(String, ArcaneStylesheet, String)>[
      ('shadcn', ShadcnStylesheet(), 'arcane'),
      ('neon', NeonStylesheet(), 'neon'),
      ('neubrutalism', NeubrutalismStylesheet(), 'neubrutalism'),
      ('win95', Win95Stylesheet(), 'win95'),
    ];

class _LegacyRenderers implements ComponentRenderers {
  const _LegacyRenderers();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LegacyStylesheet extends ShadcnStylesheet {
  const _LegacyStylesheet();

  @override
  ComponentRenderers get renderers => const _LegacyRenderers();
}

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet stylesheet,
  Widget widget,
) async {
  tester.pumpComponent(
    ArcaneThemeProvider(stylesheet: stylesheet, child: widget),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

String _openingTagForClass(String html, String className) {
  for (final RegExpMatch match in RegExp(
    r'<[^>]+class="([^"]*)"[^>]*>',
  ).allMatches(html)) {
    if (match.group(1)!.split(' ').contains(className)) {
      return match.group(0)!;
    }
  }
  fail('Missing .$className in rendered HTML');
}

void main() {
  testServer('TextArea preserves its standalone fallback renderer', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const TextArea(
        id: 'standalone-notes',
        label: 'Notes',
        helperText: 'No theme provider required',
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    final String textarea = _openingTagForClass(
      response.body,
      'arcane-textarea',
    );
    expect(textarea, contains('id="standalone-notes"'));
    expect(textarea, contains('background-color: var(--background)'));
    expect(response.body, contains('No theme provider required'));
  });

  testServer('legacy themes without the optional capability use the fallback', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const _LegacyStylesheet(),
      const TextArea(id: 'legacy-notes'),
    );
    final String textarea = _openingTagForClass(html, 'arcane-textarea');

    expect(textarea, contains('id="legacy-notes"'));
    expect(textarea, isNot(contains('shadcn-textarea')));
    expect(textarea, contains('background-color: var(--background)'));
  });

  group('TextArea renderer structure and state', () {
    for (final (String name, ArcaneStylesheet stylesheet, String prefix)
        in _themes) {
      testServer('$name preserves the public DOM and state contract', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          stylesheet,
          const TextArea(
            id: 'biography',
            name: 'biography',
            placeholder: 'Tell us about yourself',
            rows: 7,
            cols: 42,
            disabled: true,
            required: true,
            readOnly: true,
            resize: TextAreaResize.both,
            minWidth: '12rem',
            maxWidth: '36rem',
            minHeight: '8rem',
            maxHeight: '20rem',
            value: 'Existing biography',
            label: 'Biography',
            error: 'Biography is too long',
            helperText: 'This helper is hidden by the error',
            fullWidth: false,
          ),
        );

        final String wrapper = _openingTagForClass(
          html,
          'arcane-textarea-wrapper',
        );
        final String textarea = _openingTagForClass(html, 'arcane-textarea');

        expect(wrapper, contains('$prefix-textarea-wrapper'));
        expect(wrapper, contains('data-error="true"'));
        expect(wrapper, contains('data-disabled="true"'));
        expect(wrapper, contains('data-readonly="true"'));

        expect(textarea, contains('$prefix-textarea'));
        expect(textarea, contains('id="biography"'));
        expect(textarea, contains('name="biography"'));
        expect(textarea, contains('placeholder="Tell us about yourself"'));
        expect(textarea, contains('rows="7"'));
        expect(textarea, contains('cols="42"'));
        expect(textarea, contains('disabled="true"'));
        expect(textarea, contains('required="true"'));
        expect(textarea, contains('readonly="true"'));
        expect(textarea, contains('aria-invalid="true"'));
        expect(textarea, contains('data-error="true"'));
        expect(textarea, contains('data-readonly="true"'));
        expect(textarea, contains('resize: both'));
        expect(textarea, contains('min-width: 12rem'));
        expect(textarea, contains('max-width: 36rem'));
        expect(textarea, contains('min-height: 8rem'));
        expect(textarea, contains('max-height: 20rem'));
        expect(textarea, isNot(contains('width: 100%')));

        expect(html, contains('for="biography"'));
        expect(html, contains('Existing biography'));
        expect(html, contains('Biography is too long'));
        expect(html, isNot(contains('This helper is hidden by the error')));

        switch (name) {
          case 'shadcn':
            expect(textarea, contains('background-color: var(--muted)'));
            expect(textarea, contains('color: var(--muted-foreground)'));
          case 'neon':
            expect(textarea, contains('background-color: var(--muted)'));
            expect(textarea, contains('color: var(--muted-foreground)'));
          case 'neubrutalism':
            expect(textarea, contains('var(--nb-control-paper'));
            expect(textarea, contains('var(--nb-control-foreground'));
          case 'win95':
            expect(textarea, contains('background-color: var(--w95-field)'));
            expect(textarea, contains('color: var(--w95-field-text)'));
        }
      });

      testServer('$name emits helper hooks and default full width', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          stylesheet,
          const TextArea(helperText: 'Helpful guidance'),
        );
        final String textarea = _openingTagForClass(html, 'arcane-textarea');
        final String helper = _openingTagForClass(
          html,
          'arcane-textarea-helper',
        );

        expect(textarea, contains('width: 100%'));
        expect(textarea, contains('resize: vertical'));
        expect(helper, contains('$prefix-textarea-helper'));
        expect(html, contains('Helpful guidance'));
      });

      testServer('$name applies literal styles after theme styles', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          stylesheet,
          const TextArea(
            styles: ArcaneStyleData(
              widthCustom: '71%',
              backgroundCustom: '#123456',
              textColorCustom: '#abcdef',
              borderRadius: Radius.md,
            ),
          ),
        );
        final String textarea = _openingTagForClass(html, 'arcane-textarea');

        expect(textarea, contains('width: 71% !important'));
        expect(textarea, contains('background: #123456 !important'));
        expect(textarea, contains('color: #abcdef !important'));
        expect(
          textarea,
          contains('-webkit-text-fill-color: #abcdef !important'),
        );
        expect(
          textarea,
          contains('border-radius: var(--arcane-radius-md, 8px) !important'),
        );
        expect(
          textarea.indexOf('background: #123456'),
          greaterThan(textarea.indexOf('background-color:')),
        );
      });
    }
  });

  group('TextArea theme CSS contract', () {
    test(
      'ShadCN covers placeholder, focus, disabled, read-only, and error',
      () {
        final String css = const ShadcnStylesheet().baseCss;
        expect(css, contains('.arcane-textarea::placeholder'));
        expect(css, contains('.arcane-textarea:focus-visible'));
        expect(css, contains('.arcane-textarea:disabled'));
        expect(css, contains(".arcane-textarea[data-readonly='true']"));
        expect(
          css,
          matches(
            RegExp(
              r"\.arcane-textarea[^{]*:is\(\[aria-invalid='true'\], \[data-error='true'\]\)",
            ),
          ),
        );
        expect(css, contains('color: var(--muted-foreground)'));
        expect(css, contains('caret-color: var(--muted-foreground)'));
        expect(css, contains('border-color: var(--destructive)'));
      },
    );

    test('Neon covers placeholder, focus, disabled, read-only, and error', () {
      final String css = const NeonStylesheet().baseCss;
      expect(css, contains('.neon-textarea::placeholder'));
      expect(css, contains('.neon-textarea:focus'));
      expect(css, contains('.neon-textarea:disabled'));
      expect(css, contains('.neon-textarea[data-readonly="true"]'));
      expect(css, contains('.neon-textarea[data-error="true"]'));
      expect(css, contains('background: var(--muted)'));
      expect(css, contains('caret-color: var(--muted-foreground)'));
      expect(css, contains('border-color: var(--destructive)'));
    });

    test(
      'Neubrutalism covers placeholder, focus, disabled, read-only, and error',
      () {
        final String css = const NeubrutalismStylesheet().baseCss;
        expect(css, contains('.neubrutalism-textarea::placeholder'));
        expect(css, contains('.neubrutalism-textarea:focus'));
        expect(css, contains('.neubrutalism-textarea:disabled'));
        expect(css, contains('.neubrutalism-textarea[data-readonly="true"]'));
        expect(css, contains('.neubrutalism-textarea[data-error="true"]'));
        expect(css, contains('var(--nb-control-paper'));
        expect(css, contains('border-color: var(--destructive) !important'));
      },
    );

    test('Win95 keeps field text paired in light and dark modes', () {
      final String css = const Win95Stylesheet().baseCss;
      expect(css, contains('--w95-field: #ffffff;'));
      expect(css, contains('--w95-field-text: #000000;'));
      expect(css, contains('--w95-field-placeholder: #666666;'));
      expect(css, contains('--w95-field: #242424;'));
      expect(css, contains('--w95-field-text: #ffffff;'));
      expect(css, contains('--w95-field-placeholder: #bcbcbc;'));
      expect(css, contains('.arcane-textarea::placeholder'));
      expect(css, contains('.arcane-textarea:focus'));
      expect(css, contains('.arcane-textarea:disabled'));
      expect(css, contains('.arcane-textarea[data-readonly="true"]'));
      expect(css, contains('.arcane-textarea[data-error="true"]'));
      expect(css, contains('.arcane-textarea-label > span'));
      expect(css, contains('background: var(--w95-field) !important'));
      expect(css, contains('color: var(--w95-field-text) !important'));
      expect(css, contains('color: var(--w95-field-placeholder) !important'));
    });
  });
}
