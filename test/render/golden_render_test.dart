// Golden HTML snapshot safety net for the theme-renderer refactor.
//
// Each exported component (see component_cases.dart) is server-rendered under
// the three baseline stylesheets (shadcn, neon, neubrutalism). A focused Win95
// set covers its distinct field, card, and gallery DOM without multiplying the
// entire golden corpus.
//
// Modes (defaults to ASSERT):
//   * ASSERT (default)  -- the freshly rendered body must EQUAL the stored
//                          golden. Any drift fails the test. This is the
//                          contract the upcoming refactor must not break.
//   * GENERATE          -- when the golden file is missing OR the environment
//                          variable UPDATE_GOLDENS is set (and not "0"/empty),
//                          the golden file is (re)written from current output.
//
// Regenerate everything:  UPDATE_GOLDENS=1 dart test test/render/golden_render_test.dart
// Verify (default):       dart test test/render/golden_render_test.dart

import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

import 'component_cases.dart';

/// Directory (relative to the package root, which is the cwd under `dart test`)
/// that holds the golden snapshots.
const String _goldenDir = 'test/render/goldens';

/// The active stylesheets, each at its default theme.
const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
];

/// Win95 has a deliberately focused golden surface. Its extensive CSS contract
/// is covered separately; these snapshots guard the DOM hooks that contract
/// targets without adding hundreds of near-duplicate files.
const Set<String> _win95SharedCases = <String>{'Card', 'TextInput', 'TextArea'};

/// Component names excluded from golden verification because their
/// server-rendered output is irreducibly non-deterministic: each emits a
/// randomly-generated DOM id with NO public prop to pin it, so two renders of
/// the identical widget never produce byte-identical HTML. They remain fully
/// covered by the no-throw breadth suite (render_components_test.dart); only
/// golden byte-equality cannot be asserted.
///
/// Why each one cannot be pinned (without editing lib/ or packages/):
///   * ArcaneScrollArea        -- the renderer derives its scroll class from
///                                `identityHashCode(this)` (every theme); the
///                                widget exposes no `id` prop.
///   * ArcaneRangeSlider       -- deprecated wrapper that forwards to
///                                `ArcaneSlider.range` without an id, and itself
///                                exposes no `id` prop, so the slider id falls
///                                back to `identityHashCode(props)`.
///   * DialogDate / DialogDateMulti / DialogDateRange
///                             -- each wraps an inner `ArcaneDatePicker` with no
///                                id passthrough (id falls back to
///                                `identityHashCode`) and a `DateTime.now()`
///                                display month.
const Set<String> _excluded = <String>{
  'ArcaneScrollArea',
  'ArcaneRangeSlider',
  'DialogDate',
  'DialogDateMulti',
  'DialogDateRange',
};

/// True when goldens should be (re)written rather than asserted against.
bool get _updateGoldens {
  final String? value = Platform.environment['UPDATE_GOLDENS'];
  return value != null && value.isNotEmpty && value != '0';
}

Widget _wrap(ArcaneStylesheet sheet, Widget child) =>
    ArcaneThemeProvider(stylesheet: sheet, child: child);

/// Converts a case name into a filesystem-safe golden file stem.
String _sanitize(String name) =>
    name.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

/// Extracts the inner HTML of the rendered document's `<body>` element. This is
/// the per-component, per-theme DOM the renderers produce; the `<head>` (which
/// carries large theme CSS) is intentionally excluded so the snapshot focuses
/// on component output. Falls back to the full document if no `<body>` is found.
String _extractBody(String html) {
  final RegExpMatch? match = RegExp(
    r'<body[^>]*>(.*)</body>',
    dotAll: true,
  ).firstMatch(html);
  final String body = match != null ? match.group(1)! : html;
  final Map<String, String> fieldIds = <String, String>{};
  return body.replaceAllMapped(
    RegExp(r'\barcane-field-\d+\b'),
    (Match field) => fieldIds.putIfAbsent(
      field.group(0)!,
      () => 'arcane-field-${fieldIds.length}',
    ),
  );
}

void _registerCase(
  String name,
  String themeName,
  ArcaneStylesheet sheet,
  Widget widget,
) {
  testServer('$name [$themeName]', (ServerTester tester) async {
    tester.pumpComponent(_wrap(sheet, widget));
    final DocumentResponse res = await tester.request('/');
    expect(
      res.statusCode,
      200,
      reason: '$name failed to render under $themeName:\n${res.body}',
    );

    final String actual = _extractBody(res.body);
    final File file = File('$_goldenDir/${_sanitize(name)}.$themeName.html');

    if (_updateGoldens || !file.existsSync()) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(actual);
      return;
    }

    final String golden = file.readAsStringSync();
    expect(
      actual,
      golden,
      reason:
          'Golden drift for $name [$themeName] (${file.path}). '
          'Re-run with UPDATE_GOLDENS=1 only if the change is intended.',
    );
  });
}

void main() {
  final List<(String, Widget)> cases = <(String, Widget)>[
    ...componentCases(),
    ...formFieldCases(),
  ];

  for (final (String name, Widget widget) in cases) {
    if (_excluded.contains(name)) {
      continue;
    }
    for (final (String themeName, ArcaneStylesheet sheet) in _themes) {
      _registerCase(name, themeName, sheet, widget);
    }
  }

  const Win95Stylesheet win95 = Win95Stylesheet();
  for (final (String name, Widget widget) in cases) {
    if (_win95SharedCases.contains(name)) {
      _registerCase(name, 'win95', win95, widget);
    }
  }

  _registerCase(
    'CardVariants',
    'win95',
    win95,
    const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card.flat(child: Text('flat panel')),
        Card.ghost(child: Text('ghost panel')),
      ],
    ),
  );
  _registerCase(
    'ArcaneGallery',
    'win95',
    win95,
    const ArcaneGallery(
      ariaLabel: 'Example gallery',
      tiles: <ArcaneGalleryTile>[
        ArcaneGalleryTile(
          media: ArcaneGalleryMedia(
            aspectRatio: 1.5,
            src: 'example.jpg',
            alt: 'Example artwork',
          ),
          title: 'Example window',
          meta: 'Photographer',
          footer: Text('Ready'),
        ),
      ],
    ),
  );
}
