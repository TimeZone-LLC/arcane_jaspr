// One-off visual harness: renders (almost) every arcane component under the
// Windows 95 stylesheet into complete HTML documents (head CSS + the
// #arcane-root theme wrapper) so the whole component set can be screenshotted
// and audited for Win95 correctness.
//
// Run:  dart test test/render/win95_showcase.dart
// Emits: <scratch>/win95_gallery_{light,dark}.html

import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/server_test.dart';

import 'component_cases.dart';

/// Output directory for the generated preview documents (portable temp dir).
final String _scratch = (() {
  final Directory dir = Directory('${Directory.systemTemp.path}/win95_preview');
  dir.createSync(recursive: true);
  return dir.path;
})();

/// Components that render as full-screen / fixed-position overlays or floating
/// chrome — they cover the page and cannot be shown inline in a gallery grid.
bool _isOverlay(String name) {
  const List<String> needles = <String>[
    'Dialog', 'Sheet', 'Drawer', 'Toast', 'Sonner', 'Command', 'Tooltip',
    'Popover', 'Menu', 'ContextMenu', 'Dropdown', 'Promo', 'Takeover',
    'Banner', 'Modal', 'Overlay', 'Sidebar', 'Scaffold', 'Marquee', 'Fab',
    'Announcement', 'Fullscreen', 'ScrollArea', 'Carousel', 'Screen',
  ];
  for (final String n in needles) {
    if (name.contains(n)) return true;
  }
  return false;
}

String _extractBody(String html) {
  final RegExpMatch? m =
      RegExp(r'<body[^>]*>(.*)</body>', dotAll: true).firstMatch(html);
  return m != null ? m.group(1)! : html;
}

const String _demoCss = '''
.w95-demo-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;padding:16px 18px 80px;align-items:start;max-width:1400px;margin:0 auto;}
.w95-demo-cell{min-width:0;max-height:340px;overflow:auto;background:var(--w95-face);box-shadow:var(--w95-raised);padding:8px;}
.w95-demo-label{font-size:11px;margin:0 0 6px;font-weight:700;color:var(--w95-face-text);border-bottom:1px solid var(--w95-shadow);padding-bottom:3px;}
.w95-demo-title{color:#fff;text-shadow:2px 2px 0 #000;text-align:center;padding:16px 0 2px;margin:0;font-size:22px;}
.w95-demo-sub{color:#fff;text-shadow:1px 1px 0 #000;text-align:center;margin:0 0 6px;font-size:12px;opacity:.9;}
''';

String _document(
  String bodyHtml,
  String baseCss, {
  required String brightness,
  required String themeClass,
  required String bodyClass,
  required String heading,
}) {
  return '<!doctype html><html class="$brightness"><head><meta charset="utf-8">'
      '<meta name="viewport" content="width=device-width, initial-scale=1">'
      '<style>$baseCss</style><style>$_demoCss</style></head>'
      '<body><div id="arcane-root" class="$brightness $themeClass $bodyClass">'
      '<h1 class="w95-demo-title">$heading</h1>'
      '<p class="w95-demo-sub">arcane_jaspr &bull; Windows 95 &bull; component audit</p>'
      '$bodyHtml</div></body></html>';
}

/// Window chrome the shared cases leave untitled: a gallery window (caption
/// bar with its caption buttons) and a titled form section (etched group box
/// holding the bitmap radios, check box and slider).
final List<(String, Widget)> _chromeCases = <(String, Widget)>[
  (
    'ArcaneGallery',
    const ArcaneGallery(
      ariaLabel: 'Example gallery',
      tiles: <ArcaneGalleryTile>[
        ArcaneGalleryTile(
          media: ArcaneGalleryMedia(
            aspectRatio: 1.5,
            src: 'example.jpg',
            alt: 'Example artwork',
          ),
          title: 'Static at Sundown',
          meta: 'Photographer',
          footer: Text('Ready'),
        ),
      ],
    ),
  ),
  (
    'ArcaneFormSection (titled)',
    const ArcaneFormSection(
      title: 'Connection',
      description: 'How this device reaches the network.',
      children: <Widget>[
        ArcaneRadioGroup<String>(
          id: 'radio-group-chrome',
          name: 'radio-group-chrome',
          value: 'wired',
          options: <RadioOption<String>>[
            RadioOption<String>(value: 'wired', label: 'Wired'),
            RadioOption<String>(value: 'wireless', label: 'Wireless'),
            RadioOption<String>(
              value: 'modem',
              label: 'Dial-up modem',
              disabled: true,
            ),
          ],
        ),
        ArcaneCheckbox(checked: true, label: 'Reconnect at logon'),
        ArcaneSlider(id: 'slider-chrome', value: 40),
      ],
    ),
  ),
];

void main() {
  final List<(String, Widget)> cases = <(String, Widget)>[
    ...componentCases(),
    ...formFieldCases(),
    ..._chromeCases,
  ].where((c) => !_isOverlay(c.$1)).toList();

  Widget grid() => dom.div(<Widget>[
        for (final (String name, Widget widget) in cases)
          dom.div(<Widget>[
            dom.p(<Widget>[Text(name)], classes: 'w95-demo-label'),
            widget,
          ], classes: 'w95-demo-cell'),
      ], classes: 'w95-demo-grid');

  Future<String> render(ServerTester tester, ArcaneStylesheet sheet) async {
    tester.pumpComponent(ArcaneThemeProvider(stylesheet: sheet, child: grid()));
    final DocumentResponse res = await tester.request('/');
    expect(res.statusCode, 200, reason: res.body);
    return _extractBody(res.body);
  }

  testServer('win95 gallery light', (ServerTester tester) async {
    const Win95Stylesheet sheet = Win95Stylesheet();
    final String body = await render(tester, sheet);
    File('$_scratch/win95_gallery_light.html').writeAsStringSync(_document(
      body, sheet.baseCss,
      brightness: 'light',
      themeClass: sheet.themeClass,
      bodyClass: sheet.bodyClass,
      heading: 'Standard (light)',
    ));
    // ignore: avoid_print
    print('WROTE $_scratch/win95_gallery_light.html (${cases.length} components)');
  });

  testServer('win95 gallery dark', (ServerTester tester) async {
    const Win95Stylesheet sheet = Win95Stylesheet();
    final String body = await render(tester, sheet);
    File('$_scratch/win95_gallery_dark.html').writeAsStringSync(_document(
      body, sheet.baseCss,
      brightness: 'dark',
      themeClass: sheet.themeClass,
      bodyClass: sheet.bodyClass,
      heading: 'High Contrast Black (dark)',
    ));
  });
}
