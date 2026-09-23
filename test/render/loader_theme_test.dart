import 'dart:convert';
import 'dart:io';

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

const List<(Win95LoaderPalette, String)> _win95Palettes =
    <(Win95LoaderPalette, String)>[
      (
        Win95LoaderPalette.win98,
        'assets/loaders/apng/win98-hourglass_win98_1x.png',
      ),
      (
        Win95LoaderPalette.amber,
        'assets/loaders/apng/win98-hourglass_amber_1x.png',
      ),
      (
        Win95LoaderPalette.gameboy,
        'assets/loaders/apng/win98-hourglass_gameboy_1x.png',
      ),
    ];

String _extractBody(String html) {
  final RegExpMatch? match = RegExp(
    r'<body[^>]*>(.*)</body>',
    dotAll: true,
  ).firstMatch(html);
  return match?.group(1) ?? html;
}

class _LoadingSelect extends StatelessWidget {
  const _LoadingSelect();

  @override
  Widget build(BuildContext context) {
    return context.renderers.select<String>(
      const SelectProps<String>(
        id: 'loading-select',
        loading: true,
        options: <SelectOptionProps<String>>[
          SelectOptionProps<String>(value: 'a', label: 'A'),
        ],
      ),
    );
  }
}

void main() {
  for (final (String name, ArcaneStylesheet stylesheet) in _themes) {
    testServer('all $name loading surfaces use the theme loader', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: stylesheet,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ArcaneLoadingSpinner(size: '30px'),
              Button(label: 'Save', loading: true),
              ArcaneToast(
                message: 'Syncing',
                variant: ToastVariant.loading,
                duration: 0,
                dismissible: false,
              ),
            ],
          ),
        ),
      );

      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200);

      final String body = _extractBody(response.body);
      expect(
        RegExp(r'class="[^"]*\barcane-loader\b[^"]*"').allMatches(body),
        hasLength(3),
      );
    });
  }

  testServer('shadcn loading select uses the theme loader', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: ShadcnStylesheet(),
        child: _LoadingSelect(),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);

    final String body = _extractBody(response.body);
    expect(body, contains('arcane-loader arcane-loading-spinner'));
    expect(body.replaceAll(' ', ''), contains('width:16px'));
  });

  test('non-Win95 loaders stay programmatic', () {
    const List<ArcaneStylesheet> stylesheets = <ArcaneStylesheet>[
      ShadcnStylesheet(),
      NeonStylesheet(),
      NeubrutalismStylesheet(),
    ];

    for (final ArcaneStylesheet stylesheet in stylesheets) {
      expect(stylesheet.baseCss, contains('.arcane-loader {'));
      expect(stylesheet.baseCss, contains('animation: arcane-spin'));
      expect(stylesheet.baseCss, isNot(contains('--w95-loader-image')));
    }
  });

  test('Win95 loader palette selects the matching bundled APNG', () {
    final String generatedSource = File(
      'packages/arcane_jaspr_win95/lib/src/win95_loader_assets.dart',
    ).readAsStringSync();

    for (final (Win95LoaderPalette palette, String assetPath)
        in _win95Palettes) {
      final String dataUri =
          'data:image/png;base64,${base64Encode(File(assetPath).readAsBytesSync())}';
      final String css = Win95Stylesheet(loaderPalette: palette).baseCss;

      expect(generatedSource, contains("'$dataUri'"));
      expect(css, contains('--w95-loader-image: url("$dataUri")'));
      expect(css, contains('background-image: var(--w95-loader-image)'));
      expect(css, contains('image-rendering: pixelated'));
      expect(css, contains('animation: none'));
    }
  });
}
