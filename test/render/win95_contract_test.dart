import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

const Win95Stylesheet _win95 = Win95Stylesheet();

String _rule(String css, String selector) {
  final int selectorStart = css.indexOf(selector);
  if (selectorStart < 0) {
    throw StateError('Missing CSS selector: $selector');
  }
  final int bodyStart = css.indexOf('{', selectorStart);
  final int bodyEnd = css.indexOf('}', bodyStart);
  if (bodyStart < 0 || bodyEnd < 0) {
    throw StateError('Malformed CSS selector: $selector');
  }
  return css.substring(bodyStart + 1, bodyEnd);
}

/// The `url("...")` payload of a custom property declared in [block].
String _url(String block, String property) {
  final RegExpMatch? match = RegExp(
    '${RegExp.escape(property)}: url\\("([^"]+)"\\)',
  ).firstMatch(block);
  if (match == null) {
    throw StateError('Missing url() token: $property');
  }
  return match.group(1)!;
}

/// Rasterises the integer-grid SVG subset the Win95 pixel assets are authored
/// in (translate() groups and paths, each subpath a rectangle drawn with M, H,
/// V, h and v) into `"x,y" -> fill`, so a contract can assert exact pixels
/// instead of source strings.
Map<String, String> _pixels(String dataUri) {
  final String svg = Uri.decodeComponent(
    dataUri.substring(dataUri.indexOf(',') + 1),
  );
  final Map<String, String> pixels = <String, String>{};
  final List<(int, int)> origins = <(int, int)>[(0, 0)];
  final RegExp tags = RegExp(r'<(/?)(g|path)\b([^>]*)>');
  final RegExp translate = RegExp(r'translate\((-?\d+) (-?\d+)\)');
  final RegExp command = RegExp(r'([MHVhv])(-?\d+)(?: (-?\d+))?');
  for (final RegExpMatch tag in tags.allMatches(svg)) {
    if (tag.group(1) == '/') {
      origins.removeLast();
      continue;
    }
    final String attributes = tag.group(3)!;
    final RegExpMatch? shift = translate.firstMatch(attributes);
    final (int, int) origin = (
      origins.last.$1 + int.parse(shift?.group(1) ?? '0'),
      origins.last.$2 + int.parse(shift?.group(2) ?? '0'),
    );
    if (tag.group(2) == 'g') {
      origins.add(origin);
      continue;
    }
    final String fill = RegExp(
      r"fill='([^']+)'",
    ).firstMatch(attributes)!.group(1)!;
    final String path = RegExp(
      r"\bd='([^']+)'",
    ).firstMatch(attributes)!.group(1)!;
    for (final String subpath in path.split('z')) {
      if (subpath.isEmpty) {
        continue;
      }
      int x = 0;
      int y = 0;
      int minX = 1 << 20;
      int minY = 1 << 20;
      int maxX = -(1 << 20);
      int maxY = -(1 << 20);
      for (final RegExpMatch step in command.allMatches(subpath)) {
        final int value = int.parse(step.group(2)!);
        switch (step.group(1)) {
          case 'M':
            x = value;
            y = int.parse(step.group(3)!);
          case 'H':
            x = value;
          case 'V':
            y = value;
          case 'h':
            x += value;
          case 'v':
            y += value;
        }
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;
      }
      for (int py = minY; py < maxY; py++) {
        for (int px = minX; px < maxX; px++) {
          pixels['${origin.$1 + px},${origin.$2 + py}'] = fill;
        }
      }
    }
  }
  return pixels;
}

/// One raster row from [fromX] to [toX] inclusive: `X` where the pixel is
/// [ink], `.` everywhere else.
String _row(Map<String, String> pixels, int y, int fromX, int toX, String ink) {
  final StringBuffer row = StringBuffer();
  for (int x = fromX; x <= toX; x++) {
    row.write(pixels['$x,$y'] == ink ? 'X' : '.');
  }
  return row.toString();
}

/// The stepped 8x7 close cross, one string per raster row.
const List<String> _closeRows = <String>[
  'XX....XX',
  '.XX..XX.',
  '..XXXX..',
  '...XX...',
  '..XXXX..',
  '.XX..XX.',
  'XX....XX',
];

void main() {
  group('Win95 field contrast contract', () {
    final String css = _win95.baseCss;

    test('uses mode-aware field tokens for text, caret, and placeholder', () {
      expect(css, contains('--w95-field-placeholder: #666666;'));
      expect(css, contains('--w95-field-placeholder: #bcbcbc;'));
      expect(css, contains('input[type="datetime-local"]'));
      expect(css, contains('select.arcane-field-select'));
      expect(
        css,
        contains('-webkit-text-fill-color: var(--w95-field-text) !important;'),
      );
      expect(
        css,
        contains(
          '-webkit-text-fill-color: '
          'var(--w95-field-placeholder) !important;',
        ),
      );
      expect(
        css,
        contains(
          '#arcane-root.arcane-theme-win95 '
          '.win95-command-input::placeholder {\n'
          '  color: var(--w95-field-placeholder) !important;\n'
          '}',
        ),
      );
    });

    test('core field controls receive the Win95 sunken edit well', () {
      final String fieldRule = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-textarea,',
      );
      expect(fieldRule, contains('background: var(--w95-field) !important'));
      expect(fieldRule, contains('color: var(--w95-field-text) !important'));
      expect(fieldRule, contains('border-radius: 0 !important'));
      expect(fieldRule, contains('box-shadow: var(--w95-sunken) !important'));
    });
  });

  group('Win95 surface contracts', () {
    final String css = _win95.baseCss;

    test('flat cards keep a thin panel frame while ghost cards do not', () {
      final String flat = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '.win95-card[data-variant="flat"]',
      );
      final String ghost = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '.win95-card[data-variant="ghost"]',
      );

      expect(flat, contains('box-shadow: var(--w95-raised-thin)'));
      expect(ghost, contains('box-shadow: none'));
      expect(ghost, contains('background: transparent'));
    });

    test('gallery windows have a frame and tokenized caption contrast', () {
      final String tile = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile',
      );
      final String title = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile-title',
      );
      final String meta = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile-meta',
      );

      expect(tile, contains('border: 1px solid var(--w95-dark)'));
      expect(title, contains('color: var(--w95-title-text)'));
      expect(meta, contains('color: var(--w95-title-text)'));
      expect(meta, contains('opacity: 0.78'));
      expect(meta, isNot(contains('rgba(')));
    });
  });

  group('Win95 vintage drag contract', () {
    final String css = _win95.baseCss;

    test('captions default to solid navy; gradient stays a host override', () {
      expect(css, contains('--w95-title-bar: var(--w95-title-a);'));
      expect(css, isNot(contains('linear-gradient(90deg, var(--w95-title-a)')));
    });

    test('inactive gallery captions flip to the solid gray scheme', () {
      final String inactive = _rule(
        css,
        '#arcane-root.arcane-theme-win95 [data-w95-active="false"] '
        '.win95-gallery-tile-header',
      );
      expect(inactive, contains('background: var(--w95-title-inactive-a)'));
      expect(
        inactive,
        contains('--w95-title-text: var(--w95-title-inactive-text)'),
      );
      expect(css, contains('--w95-title-inactive-text: #c0c0c0;'));
      // An inactive caption is one solid colour; a second stop only exists so
      // a gradient can be built, and gradients are a Windows 98 feature.
      expect(css, isNot(contains('--w95-title-inactive-b')));
    });

    test('pixel-art cursor set is exposed as custom properties', () {
      const List<String> cursorProperties = <String>[
        '--w95-cursor-arrow: url("data:image/png;base64,',
        '--w95-cursor-wait: url("data:image/png;base64,',
        '--w95-cursor-ibeam: url("data:image/png;base64,',
        '--w95-cursor-crosshair: url("data:image/png;base64,',
        '--w95-cursor-no: url("data:image/png;base64,',
        '--w95-cursor-hand: url("data:image/png;base64,',
        '--w95-cursor-move: url("data:image/png;base64,',
        '--w95-cursor-ns: url("data:image/png;base64,',
        '--w95-cursor-ew: url("data:image/png;base64,',
        '--w95-cursor-nwse: url("data:image/png;base64,',
        '--w95-cursor-nesw: url("data:image/png;base64,',
      ];
      for (final String property in cursorProperties) {
        expect(css, contains(property));
      }
      // Every embedded cursor carries a keyword fallback after its hotspot.
      expect(css, contains(') 0 0, default;'));
      expect(css, contains(', move;'));
      expect(css, contains(', wait;'));
    });

    test('drag surfaces use the Win95 arrow, never grab hands', () {
      expect(css, isNot(contains('cursor: grab')));
      final String thumb = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-slider-thumb',
      );
      expect(thumb, contains('cursor: var(--w95-cursor-arrow) !important'));
      final String handle = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '[data-arcane-gallery-draggable="true"] '
        '[data-arcane-drag-handle="true"]',
      );
      expect(handle, contains('cursor: var(--w95-cursor-arrow)'));
      final String header = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile-header {',
      );
      expect(header, contains('cursor: var(--w95-cursor-arrow)'));
    });

    test('the desktop root sets the arrow so the whole shell inherits it', () {
      final String desktop = _rule(
        css,
        '#arcane-root.arcane-theme-win95 {\n  background: var(--w95-desktop);',
      );
      expect(desktop, contains('cursor: var(--w95-cursor-arrow);'));
      // A universal cursor rule would outrank the I-beam/hourglass exceptions.
      final String universal = _rule(
        css,
        '#arcane-root.arcane-theme-win95,\n'
        '#arcane-root.arcane-theme-win95 *',
      );
      expect(universal, isNot(contains('cursor')));
    });

    test('every themed cursor resolves to a bitmap token, never a keyword', () {
      // componentCss also carries the unscoped core docs/map stylesheets, so
      // only rules the theme itself owns are in scope here.
      final List<String> offenders = <String>[];
      String selector = '';
      for (final String line in _win95.componentCss.split('\n')) {
        final String trimmed = line.trim();
        if (trimmed.endsWith('{') || trimmed.endsWith(',')) {
          selector = trimmed.endsWith(',') ? '$selector $trimmed' : trimmed;
          continue;
        }
        if (trimmed.startsWith('}')) {
          selector = '';
          continue;
        }
        if (!trimmed.startsWith('cursor:')) {
          continue;
        }
        if (!selector.contains('.arcane-theme-win95')) {
          continue;
        }
        if (!trimmed.contains('var(--w95-cursor-')) {
          offenders.add('$selector => $trimmed');
        }
      }
      expect(offenders, isEmpty);
    });

    test('UA-defaulted form controls name the arrow instead of inheriting', () {
      // Chromium's UA sheet sets `cursor: default` on buttons, labels, summary
      // and the non-text inputs, which outranks the inherited root arrow.
      final String controls = _rule(
        css,
        '#arcane-root.arcane-theme-win95 button,\n'
        '#arcane-root.arcane-theme-win95 summary,',
      );
      expect(controls, contains('cursor: var(--w95-cursor-arrow);'));
      for (final String selector in <String>[
        '#arcane-root.arcane-theme-win95 label,',
        '#arcane-root.arcane-theme-win95 input[type="checkbox"],',
        '#arcane-root.arcane-theme-win95 input[type="radio"],',
        '#arcane-root.arcane-theme-win95 input[type="range"],',
      ]) {
        expect(css, contains(selector), reason: selector);
      }
    });

    test('unscoped core chrome that hard-codes the hand is reclaimed', () {
      final String reclaimed = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .code-copy-button,',
      );
      expect(reclaimed, contains('cursor: var(--w95-cursor-arrow);'));
    });

    test('the IE hand is scoped to hypertext, never to controls', () {
      final String hypertext = _rule(
        css,
        '#arcane-root.arcane-theme-win95 a[href]:not([class]),',
      );
      expect(hypertext, contains('cursor: var(--w95-cursor-hand);'));
      final String crumb = _rule(
        css,
        '#arcane-root.arcane-theme-win95 a.win95-breadcrumb-link[href]',
      );
      expect(crumb, contains('cursor: var(--w95-cursor-hand) !important;'));
      // The button beside it is a control and keeps the arrow.
      final String crumbBase = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-breadcrumb-link,\n'
        '#arcane-root.arcane-theme-win95 .win95-breadcrumb-button',
      );
      expect(
        crumbBase,
        contains('cursor: var(--w95-cursor-arrow) !important;'),
      );
    });

    test('edit wells take the I-beam and busy regions the hourglass', () {
      final String wells = _rule(
        css,
        '#arcane-root.arcane-theme-win95 input:not([type="checkbox"])',
      );
      expect(wells, contains('cursor: var(--w95-cursor-ibeam) !important;'));
      final String readonly = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-textarea[data-readonly="true"]',
      );
      expect(readonly, contains('cursor: var(--w95-cursor-ibeam) !important;'));
      final String busy = _rule(
        css,
        '#arcane-root.arcane-theme-win95[data-busy="true"],',
      );
      expect(busy, contains('cursor: var(--w95-cursor-wait) !important;'));
    });

    test('core inline-cursor seams are retargeted at the bitmap set', () {
      expect(css, contains('--arcane-drag-cursor: var(--w95-cursor-arrow);'));
      expect(css, contains('--arcane-step-cursor: var(--w95-cursor-arrow);'));
      expect(
        css,
        contains('--arcane-step-cursor-disabled: var(--w95-cursor-arrow);'),
      );
      expect(css, contains('--arcane-resize-cursor-ew: var(--w95-cursor-ew);'));
      expect(css, contains('--arcane-resize-cursor-ns: var(--w95-cursor-ns);'));
    });

    test('outline drag wireframe is a hard XOR-style rectangle', () {
      final String outline = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-gallery-drag-outline',
      );
      expect(outline, contains('mix-blend-mode: difference'));
      expect(outline, contains('border: 4px solid #ffffff'));
      expect(outline, isNot(contains('transition')));
    });
  });

  group('Win95 zero-motion contract', () {
    final String css = _win95.baseCss;

    test('the theme scope carries a blanket motion reset', () {
      final String reset = _rule(
        css,
        '#arcane-root.arcane-theme-win95 *,\n'
        '#arcane-root.arcane-theme-win95 *::before,\n'
        '#arcane-root.arcane-theme-win95 *::after {\n'
        '  transition: none !important;',
      );
      expect(reset, contains('transition: none !important;'));
      expect(reset, contains('animation: none !important;'));
    });

    test('timing tokens are zeroed at their source, aliases included', () {
      const List<String> zeroed = <String>[
        '--transition-fast: 0s;',
        '--transition: 0s;',
        '--transition-slow: 0s;',
        '--transition-slower: 0s;',
        '--arcane-transition-fast: 0s;',
        '--arcane-transition: 0s;',
        '--arcane-transition-slow: 0s;',
        '--arcane-transition-slower: 0s;',
      ];
      for (final String token in zeroed) {
        expect(css, contains(token), reason: token);
      }
    });

    test('anything revealed by a keyframe is pinned opaque', () {
      final String ctaCard = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-cta-card',
      );
      expect(ctaCard, contains('opacity: 1 !important;'));
    });
  });

  group('Win95 chrome fidelity contract', () {
    final String css = _win95.baseCss;

    test('the default push button ring is a real border, not an inset', () {
      final String primary = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-button[data-variant="primary"]',
      );
      // An inset ring behind --w95-raised is fully occluded and never paints.
      expect(primary, contains('border: 1px solid var(--w95-dark);'));
      expect(primary, contains('box-shadow: var(--w95-raised);'));
      expect(primary, isNot(contains('inset 0 0 0 1px')));
    });

    test('no blurred or alpha-composited shadow survives the theme', () {
      // componentCss is the sheet the theme itself owns; baseCss additionally
      // carries the core --shadow-* token block, which no Win95 rule spends.
      final String themeCss = _win95.componentCss;
      expect(themeCss, isNot(contains('rgba(0, 0, 0, 0.35)')));
      expect(themeCss, isNot(contains('10px rgba(')));
      expect(themeCss, isNot(contains('blur(')));
    });

    test('scrollbars are the 16px SM_CXVSCROLL module, defined once', () {
      final String bar = _rule(
        css,
        '#arcane-root.arcane-theme-win95 ::-webkit-scrollbar {',
      );
      expect(bar, contains('width: 16px !important;'));
      expect(bar, contains('height: 16px !important;'));
      // The theme owns exactly one scrollbar definition, and it is on-module.
      expect(_win95.componentCss, isNot(contains('width: 17px')));
      final String button = _rule(
        css,
        '#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button {',
      );
      expect(button, contains('width: 16px !important;'));
      expect(button, contains('height: 16px !important;'));
      // The track dither resolves through tokens so High Contrast re-points it.
      final String track = _rule(
        css,
        '#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-track {',
      );
      expect(track, contains('background-color: var(--w95-field) !important;'));
      expect(track, isNot(contains('#ffffff')));
    });

    test('the checkbox tick and caption glyphs are drawn, not typed', () {
      expect(css, contains('--w95-check: url('));
      final String tick = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '.win95-checkbox-box[data-state="checked"]::after,',
      );
      expect(tick, contains('mask-image: var(--w95-check);'));
      expect(tick, isNot(contains('font-size')));

      final String caption = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-dialog-close,\n'
        '#arcane-root.arcane-theme-win95 .win95-drawer-close,\n'
        '#arcane-root.arcane-theme-win95 .win95-sheet-close',
      );
      expect(caption, contains('width: 16px !important;'));
      expect(caption, contains('height: 14px !important;'));
      expect(caption, contains('box-shadow: var(--w95-raised) !important;'));
      // font-size: 0 collapses the U+2715 the shared render base emits.
      expect(caption, contains('font-size: 0 !important;'));
    });

    test('disabled labels are engraved, not flat grey', () {
      final String engraved = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-menubar-item[aria-disabled="true"],',
      );
      expect(engraved, contains('color: var(--w95-disabled-text) !important;'));
      expect(
        engraved,
        contains('text-shadow: 1px 1px 0 var(--w95-hilite) !important;'),
      );
    });

    test('the checkbox focus rectangle lands on the caption', () {
      final String well = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper'
        ':has(> div:nth-child(2)) .win95-checkbox-box:focus-visible',
      );
      expect(well, contains('outline: none !important;'));

      final String caption = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper'
        ':has(.win95-checkbox-box:focus-visible) > div:nth-child(2)',
      );
      expect(
        caption,
        contains('outline: 1px dotted var(--w95-face-text) !important;'),
      );
    });
  });

  group('Win95 caption control contract', () {
    final String css = _win95.baseCss;
    final String light = _rule(
      css,
      '#arcane-root.arcane-theme-win95 {\n  /* --- Palette overrides',
    );
    final String dark = _rule(css, '#arcane-root.arcane-theme-win95.dark {');
    const List<String> sprites = <String>[
      '--w95-caption-buttons',
      '--w95-caption-min-max',
      '--w95-caption-close',
    ];

    test('caption sprites are bevelled 16x14 caps with stepped glyphs', () {
      final Map<String, String> buttons = _pixels(
        _url(light, '--w95-caption-buttons'),
      );
      expect(_url(light, '--w95-caption-buttons'), contains("'0 0 50 14'"));
      expect(_url(light, '--w95-caption-min-max'), contains("'0 0 32 14'"));
      expect(_url(light, '--w95-caption-close'), contains("'0 0 16 14'"));
      for (final String sprite in sprites) {
        expect(_url(light, sprite), contains("shape-rendering='crispEdges'"));
        expect(_url(light, sprite), isNot(contains('stroke')));
      }

      // Each cap: outer top-left white, inner top-left #dfdfdf, inner
      // bottom-right #808080, outer bottom-right black, #c0c0c0 face.
      for (final int cap in <int>[0, 16, 34]) {
        expect(buttons['${cap + 0},0'], '#ffffff', reason: 'cap $cap');
        expect(buttons['${cap + 0},12'], '#ffffff', reason: 'cap $cap');
        expect(buttons['${cap + 1},1'], '#dfdfdf', reason: 'cap $cap');
        expect(buttons['${cap + 14},12'], '#808080', reason: 'cap $cap');
        expect(buttons['${cap + 14},1'], '#808080', reason: 'cap $cap');
        expect(buttons['${cap + 15},0'], '#000000', reason: 'cap $cap');
        expect(buttons['${cap + 0},13'], '#000000', reason: 'cap $cap');
        expect(buttons['${cap + 2},2'], '#c0c0c0', reason: 'cap $cap');
      }
      // Minimize and maximize touch; a 2px gap sits before the close cap.
      for (int y = 0; y < 14; y++) {
        expect(buttons['32,$y'], isNull);
        expect(buttons['33,$y'], isNull);
      }

      // Minimize: a 6x2 bar at x4-9, y9-10, one face row above the bevel.
      expect(_row(buttons, 9, 3, 10, '#000000'), '.XXXXXX.');
      expect(_row(buttons, 10, 3, 10, '#000000'), '.XXXXXX.');
      expect(_row(buttons, 8, 3, 10, '#000000'), '........');
      expect(_row(buttons, 11, 3, 10, '#000000'), '........');
      // Maximize: a 9x9 box at x3-11, y2-10 with a 2px top edge.
      expect(_row(buttons, 2, 18, 28, '#000000'), '.XXXXXXXXX.');
      expect(_row(buttons, 3, 18, 28, '#000000'), '.XXXXXXXXX.');
      for (int y = 4; y < 10; y++) {
        expect(_row(buttons, y, 18, 28, '#000000'), '.X.......X.');
      }
      expect(_row(buttons, 10, 18, 28, '#000000'), '.XXXXXXXXX.');
      // Close: the stepped 8x7 cross at x4-11, y3-9.
      for (int y = 0; y < _closeRows.length; y++) {
        expect(_row(buttons, y + 3, 38, 45, '#000000'), _closeRows[y]);
      }
      final Map<String, String> close = _pixels(
        _url(light, '--w95-caption-close'),
      );
      for (int y = 0; y < _closeRows.length; y++) {
        expect(_row(close, y + 3, 4, 11, '#000000'), _closeRows[y]);
      }
    });

    test('the dark scheme re-points all three sprites', () {
      for (final String sprite in sprites) {
        final String darkSprite = _url(dark, sprite);
        expect(darkSprite, isNot(_url(light, sprite)), reason: sprite);
        final Map<String, String> pixels = _pixels(darkSprite);
        expect(pixels['0,0'], '#8e8e8e', reason: sprite);
        expect(pixels['1,1'], '#646464', reason: sprite);
        expect(pixels['14,12'], '#1c1c1c', reason: sprite);
        expect(pixels['15,0'], '#000000', reason: sprite);
        expect(pixels['2,2'], '#3a3a3a', reason: sprite);
      }
      final Map<String, String> close = _pixels(
        _url(dark, '--w95-caption-close'),
      );
      for (int y = 0; y < _closeRows.length; y++) {
        expect(_row(close, y + 3, 4, 11, '#ffffff'), _closeRows[y]);
      }
    });

    test('gallery captions and the command palette carry the sprite', () {
      final String controls = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile-header::after',
      );
      expect(controls, contains("content: '';"));
      expect(controls, contains('position: absolute;'));
      // Centred on the caption's height: 2px in on an 18px bar, and still
      // centred when a title plus meta line makes the caption taller.
      expect(controls, contains('top: 0;'));
      expect(controls, contains('bottom: 0;'));
      expect(controls, contains('margin: auto 0;'));
      expect(controls, contains('right: 2px;'));
      expect(controls, contains('width: 50px;'));
      expect(controls, contains('height: 14px;'));
      expect(
        controls,
        contains(
          'background: var(--w95-caption-buttons) no-repeat center / '
          '50px 14px;',
        ),
      );
      expect(controls, contains('pointer-events: none;'));

      final String header = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile-header {',
      );
      expect(header, contains('position: relative;'));
      expect(header, contains('min-height: 18px;'));
      expect(header, contains('padding: 2px 58px 2px 6px;'));
      // Activation never changed the caption buttons in Windows 95.
      expect(
        css,
        isNot(
          contains('[data-w95-active="false"] .win95-gallery-tile-header::'),
        ),
      );

      final String palette = _rule(
        css,
        '#arcane-root.arcane-theme-win95:not(.win95-chrome-minimal) '
        '.win95-command-dialog::after',
      );
      expect(palette, contains('var(--w95-caption-buttons)'));
      expect(palette, contains('width: 50px;'));
      expect(palette, contains('height: 14px;'));
      final String window = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-command-dialog {',
      );
      expect(window, contains('position: relative;'));
    });

    test('the live close glyph is the stepped bitmap cross', () {
      final String glyph = _url(light, '--w95-ctl-close');
      expect(glyph, isNot(contains('stroke-width')));
      expect(glyph, contains("shape-rendering='crispEdges'"));
      expect(css, isNot(contains('stroke-width')));
      // A 10x10 mask cell centred in the 16x14 cap (offset 3,2) puts the
      // cross on the same x4-11, y3-9 pixels as the caption sprite.
      final Map<String, String> pixels = _pixels(glyph);
      for (int y = 0; y < _closeRows.length; y++) {
        expect(_row(pixels, y + 1, 1, 8, '#000000'), _closeRows[y]);
      }
      final String pressed = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-dialog-close:active,',
      );
      expect(pressed, contains('box-shadow: var(--w95-pressed) !important;'));
      // An even 14x12 content box keeps the 10x10 cell on whole pixels, so
      // the glyph steps exactly one pixel down-right.
      expect(pressed, contains('padding: 2px 0 0 2px !important;'));
    });
  });

  group('Win95 window frame contract', () {
    final String css = _win95.baseCss;
    final String light = _rule(
      css,
      '#arcane-root.arcane-theme-win95 {\n  /* --- Palette overrides',
    );

    test('windows use the frame bevel, not the push-button bevel', () {
      // First-listed shadows paint on top: the outer 1px ring is #dfdfdf
      // top-left and black bottom-right, the inner ring white and #808080.
      expect(
        light,
        contains(
          '--w95-window-frame:\n'
          '    inset -1px -1px 0 var(--w95-dark),\n'
          '    inset 1px 1px 0 var(--w95-light),\n'
          '    inset -2px -2px 0 var(--w95-shadow),\n'
          '    inset 2px 2px 0 var(--w95-hilite);',
        ),
      );
      expect(light, contains('--w95-dark: #000000;'));
    });

    test('every window, menu and popup surface spends the frame token', () {
      const List<String> frames = <String>[
        '#arcane-root.arcane-theme-win95 .win95-dialog {',
        '#arcane-root.arcane-theme-win95 .win95-drawer {',
        '#arcane-root.arcane-theme-win95 .win95-sheet {',
        '#arcane-root.arcane-theme-win95 .arcane-scaffold {',
        '#arcane-root.arcane-theme-win95 .win95-gallery-tile {',
        '#arcane-root.arcane-theme-win95 .win95-command-dialog {\n  width',
        '#arcane-root.arcane-theme-win95 .win95-dropdown-menu,\n'
            '#arcane-root.arcane-theme-win95 .win95-popover,\n'
            '#arcane-root.arcane-theme-win95 .win95-select-dropdown {',
        '#arcane-root.arcane-theme-win95 .win95-popover,\n'
            '#arcane-root.arcane-theme-win95 .win95-context-menu,',
        '#arcane-root.arcane-theme-win95 .win95-date-picker-dropdown {',
        '#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown {',
        '#arcane-root.arcane-theme-win95 .arcane-combobox-dropdown {',
        '#arcane-root.arcane-theme-win95 .arcane-mega-menu-panel {',
      ];
      for (final String selector in frames) {
        final String rule = _rule(css, selector);
        expect(rule, contains('var(--w95-window-frame)'), reason: selector);
        expect(rule, isNot(contains('var(--w95-raised)')), reason: selector);
      }
      // Buttons keep the push-button bevel.
      expect(
        _rule(css, '#arcane-root.arcane-theme-win95 .win95-button {'),
        contains('box-shadow: var(--w95-raised);'),
      );
    });
  });

  group('Win95 control fidelity contract', () {
    final String css = _win95.baseCss;
    final String light = _rule(
      css,
      '#arcane-root.arcane-theme-win95 {\n  /* --- Palette overrides',
    );
    final String dark = _rule(css, '#arcane-root.arcane-theme-win95.dark {');

    test('the active tab paints its 1px hilite and dark edges on top', () {
      final String tab = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-tabs-trigger.active {',
      );
      expect(
        tab,
        contains(
          'box-shadow:\n'
          '    inset 1px 1px 0 var(--w95-hilite),\n'
          '    inset 2px 2px 0 var(--w95-light),\n'
          '    inset -1px 0 0 var(--w95-dark),\n'
          '    inset -2px 0 0 var(--w95-shadow) !important;',
        ),
      );
    });

    test('disabled text is COLOR_GRAYTEXT over the white emboss', () {
      expect(light, contains('--w95-disabled-text: #808080;'));
      final String button = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-button[data-disabled="true"]',
      );
      expect(button, contains('text-shadow: 1px 1px 0 var(--w95-hilite);'));
    });

    test('radios are the 12x12 four-shade bitmap with a 4x4 dot', () {
      final String radio = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        ':is(.win95-radio-control, input[type="radio"]) {',
      );
      expect(radio, contains('flex: 0 0 12px;'));
      expect(radio, contains('width: 12px;'));
      expect(radio, contains('height: 12px;'));
      expect(radio, contains('border-radius: 0 !important;'));
      expect(radio, isNot(contains('50%')));
      expect(radio, contains('box-shadow: none;'));
      expect(
        radio,
        contains(
          'background: var(--w95-radio-ring) 0 0 / 12px 12px no-repeat, '
          'var(--w95-field);',
        ),
      );
      expect(
        radio,
        contains('mask: var(--w95-radio-mask) 0 0 / 12px 12px no-repeat;'),
      );
      final String checked = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        ':is(.win95-radio-control, input[type="radio"]):checked {',
      );
      expect(checked, contains('var(--w95-field-text)'));
      expect(checked, isNot(contains('radial-gradient')));

      final Map<String, String> ring = _pixels(_url(light, '--w95-radio-ring'));
      expect(ring['4,0'], '#808080');
      expect(ring['0,5'], '#808080');
      expect(ring['4,1'], '#000000');
      expect(ring['1,5'], '#000000');
      expect(ring['4,10'], '#dfdfdf');
      expect(ring['10,5'], '#dfdfdf');
      expect(ring['4,11'], '#ffffff');
      expect(ring['11,5'], '#ffffff');
      // The field is left clear for var(--w95-field) to show through.
      expect(ring['5,5'], isNull);

      final Map<String, String> darkRing = _pixels(
        _url(dark, '--w95-radio-ring'),
      );
      expect(darkRing['4,0'], '#1c1c1c');
      expect(darkRing['4,1'], '#000000');
      expect(darkRing['4,10'], '#646464');
      expect(darkRing['4,11'], '#8e8e8e');

      final Map<String, String> mask = _pixels(_url(light, '--w95-radio-mask'));
      expect(mask['0,0'], isNull);
      expect(mask['11,11'], isNull);
      expect(mask['3,0'], isNull);
      expect(mask['4,0'], isNotNull);
      expect(mask['0,4'], isNotNull);
      expect(mask['5,5'], isNotNull);
    });

    test('the checkbox well is 13px around the 7x7 tick', () {
      final String box = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-box {',
      );
      expect(box, contains('width: 13px;'));
      expect(box, contains('height: 13px;'));
      final String tick = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '.win95-checkbox-box[data-state="checked"]::after,',
      );
      expect(tick, contains('width: 7px;'));
      expect(tick, contains('height: 7px;'));
    });

    test('scroll arrows are stepped 7x4 bitmaps with a flat pressed frame', () {
      const Map<String, List<String>> arrows = <String, List<String>>{
        '--w95-scroll-up': <String>['...X...', '..XXX..', '.XXXXX.', 'XXXXXXX'],
        '--w95-scroll-down': <String>[
          'XXXXXXX',
          '.XXXXX.',
          '..XXX..',
          '...X...',
        ],
      };
      for (final MapEntry<String, List<String>> arrow in arrows.entries) {
        final String uri = _url(light, arrow.key);
        expect(uri, contains("shape-rendering='crispEdges'"));
        final Map<String, String> pixels = _pixels(uri);
        for (int y = 0; y < 4; y++) {
          expect(
            _row(pixels, y + 6, 4, 10, '#000000'),
            arrow.value[y],
            reason: arrow.key,
          );
        }
        expect(
          _row(_pixels(_url(dark, arrow.key)), 9, 4, 10, '#ffffff'),
          _row(pixels, 9, 4, 10, '#000000'),
        );
      }
      final Map<String, String> left = _pixels(
        _url(light, '--w95-scroll-left'),
      );
      expect(_row(left, 7, 5, 10, '#000000'), '.XXXX.');
      expect(_row(left, 4, 5, 10, '#000000'), '....X.');
      final Map<String, String> right = _pixels(
        _url(light, '--w95-scroll-right'),
      );
      expect(_row(right, 7, 5, 10, '#000000'), '.XXXX.');
      expect(_row(right, 4, 5, 10, '#000000'), '.X....');
      for (final String side in <String>['left', 'right']) {
        expect(
          _url(dark, '--w95-scroll-$side'),
          isNot(_url(light, '--w95-scroll-$side')),
        );
      }

      expect(
        _rule(
          css,
          '#arcane-root.arcane-theme-win95 '
          '::-webkit-scrollbar-button:vertical:decrement {',
        ),
        contains('background-image: var(--w95-scroll-up) !important;'),
      );
      expect(
        _rule(
          css,
          '#arcane-root.arcane-theme-win95 '
          '::-webkit-scrollbar-button:horizontal:increment {',
        ),
        contains('background-image: var(--w95-scroll-right) !important;'),
      );
      // The dark scheme re-points the tokens instead of restating the rules.
      expect(
        css,
        isNot(
          contains('#arcane-root.arcane-theme-win95.dark ::-webkit-scrollbar'),
        ),
      );
      final String pressed = _rule(
        css,
        '#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:active {',
      );
      expect(
        pressed,
        contains('box-shadow: inset 0 0 0 1px var(--w95-shadow) !important;'),
      );
      expect(pressed, contains('background-position: 1px 1px !important;'));
      expect(pressed, isNot(contains('--w95-pressed')));
    });

    test('the page-level scrollbar copy resolves through tokens', () {
      final String page = _rule(
        css,
        'html:has(#arcane-root.arcane-theme-win95) {',
      );
      expect(page, contains('--w95-face: #c0c0c0;'));
      expect(page, contains('--w95-dark: #000000;'));
      expect(page, contains('--w95-scroll-up: url("data:image/svg+xml,'));
      expect(
        _rule(
          css,
          'html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-thumb {',
        ),
        contains('box-shadow: var(--w95-raised);'),
      );
      expect(
        _rule(
          css,
          'html:has(#arcane-root.arcane-theme-win95)'
          '::-webkit-scrollbar-button:active {',
        ),
        contains('box-shadow: inset 0 0 0 1px var(--w95-shadow);'),
      );
      // Only custom-property declarations may carry a literal colour.
      final RegExp hex = RegExp(r'#[0-9a-fA-F]{3,6}\b');
      final List<String> offenders = <String>[];
      String selector = '';
      for (final String line in _win95.componentCss.split('\n')) {
        final String trimmed = line.trim();
        if (trimmed.endsWith('{') || trimmed.endsWith(',')) {
          selector = trimmed.endsWith(',') ? '$selector $trimmed' : trimmed;
          continue;
        }
        if (trimmed.startsWith('}')) {
          selector = '';
          continue;
        }
        if (!selector.startsWith('html') || trimmed.startsWith('--')) {
          continue;
        }
        if (hex.hasMatch(trimmed.replaceAll('%23', ''))) {
          offenders.add('$selector => $trimmed');
        }
      }
      expect(offenders, isEmpty);
      expect(_win95.componentCss, isNot(contains('#0a0a0a')));
    });

    test('the progress trough is a 1px sunken well', () {
      final String trough = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-progress,\n'
        '#arcane-root.arcane-theme-win95 .win95-progress-track {',
      );
      expect(trough, contains('box-shadow: var(--w95-sunken-thin);'));
    });

    test('the slider is a sunken channel under a pointed thumb', () {
      final String track = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-slider-track {',
      );
      expect(track, contains('height: 4px !important;'));
      expect(track, contains('box-shadow: var(--w95-sunken) !important;'));
      final String fill = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-slider-track-fill {',
      );
      expect(fill, contains('display: none !important;'));
      expect(fill, isNot(contains('--w95-selection')));
      final String thumb = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-slider-thumb {',
      );
      expect(thumb, contains('width: 11px !important;'));
      expect(thumb, contains('height: 21px !important;'));
      expect(
        thumb,
        contains(
          'background: var(--w95-slider-thumb) no-repeat 0 0 / 11px 21px '
          '!important;',
        ),
      );
      expect(thumb, contains('box-shadow: none !important;'));
      // Whole-pixel offsets keep the bitmap off half pixels.
      expect(thumb, contains('transform: translate(-5px, -10px) !important;'));

      final Map<String, String> pixels = _pixels(
        _url(light, '--w95-slider-thumb'),
      );
      expect(pixels['0,0'], '#ffffff');
      expect(pixels['1,1'], '#dfdfdf');
      expect(pixels['9,1'], '#808080');
      expect(pixels['10,0'], '#000000');
      expect(pixels['5,5'], '#c0c0c0');
      expect(pixels['5,20'], '#000000');
      expect(pixels['4,19'], '#ffffff');
      expect(pixels['0,16'], isNull);
      expect(pixels['10,16'], isNull);
      expect(pixels['4,20'], isNull);
      final Map<String, String> darkThumb = _pixels(
        _url(dark, '--w95-slider-thumb'),
      );
      expect(darkThumb['0,0'], '#8e8e8e');
      expect(darkThumb['5,5'], '#3a3a3a');
    });

    test('group boxes are etched frames with the caption on the face', () {
      final String group = _rule(
        css,
        '#arcane-root.arcane-theme-win95 fieldset,\n'
        '#arcane-root.arcane-theme-win95 .win95-fieldset {',
      );
      expect(group, contains('border: 1px solid var(--w95-shadow);'));
      expect(
        group,
        contains(
          'box-shadow: inset 1px 1px 0 var(--w95-hilite), '
          '1px 1px 0 var(--w95-hilite);',
        ),
      );
      expect(group, contains('border-radius: 0;'));
      final String legend = _rule(
        css,
        '#arcane-root.arcane-theme-win95 fieldset > legend,',
      );
      expect(legend, contains('background: var(--w95-face);'));
      expect(legend, contains('padding: 0 2px;'));
    });

    test('menubar titles highlight only while their menu is open', () {
      expect(css, isNot(contains('.win95-menubar-trigger:hover')));
      final String open = _rule(
        css,
        '#arcane-root.arcane-theme-win95 '
        '.win95-menubar-trigger[aria-expanded="true"],',
      );
      expect(open, contains('background: var(--w95-selection) !important;'));
    });
  });

  testServer('a Win95 form section puts its caption in the group box frame', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: _win95,
        brightness: Brightness.light,
        includeFallbackScripts: false,
        home: ArcaneFormSection(
          title: 'Connection',
          description: 'How this device reaches the network.',
          children: <Widget>[Text('field')],
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    expect(
      response.body,
      matches(
        RegExp(r'<fieldset class="win95-form-section">\s*<legend>Connection'),
      ),
    );
    expect(response.body, contains('How this device reaches the network.'));
  });

  testServer('ArcaneApp delegates its canvas to the stylesheet hook', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: _win95,
        brightness: Brightness.light,
        includeFallbackScripts: false,
        home: Text('desktop'),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    expect(
      response.body,
      contains(
        'background-color: '
        'var(--arcane-app-background, var(--background))',
      ),
    );
    expect(
      response.body,
      contains('--arcane-app-background: var(--w95-desktop)'),
    );
    expect(
      response.body,
      contains('color: var(--arcane-app-foreground, var(--foreground))'),
    );
    expect(
      response.body,
      contains('--arcane-app-foreground: var(--w95-desktop-text)'),
    );
  });

  test('every Win95 desktop scheme has a paired AA foreground', () {
    for (final Win95Theme theme in Win95Theme.values) {
      final int foreground = PaletteGenerator.contrastingForeground(
        theme.desktop,
      );
      final double contrast = PaletteGenerator.contrastRatio(
        theme.desktop,
        foreground,
      );
      final String css = Win95Stylesheet(theme: theme).componentCss;

      expect(
        contrast,
        greaterThanOrEqualTo(4.5),
        reason: '${theme.label} desktop contrast is $contrast',
      );
      expect(
        css,
        contains(
          '--w95-desktop-text: var(--w95-desktop-text-in, '
          '${PaletteGenerator.toHex(foreground)})',
        ),
      );
    }
  });
}
