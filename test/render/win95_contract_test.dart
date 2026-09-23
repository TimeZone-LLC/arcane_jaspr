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
