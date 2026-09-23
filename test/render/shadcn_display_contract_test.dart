// ShadCN v4 display/data contract: card family, badge, alert, separator,
// skeleton, progress, slider, tables, kbd, avatar and picker triggers render
// the v4 tokens inline and hand hover/focus state to the display CSS part
// through `var(--shadcn-*)` hooks.

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr/component/input/time_picker.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

const ShadcnStylesheet _sheet = ShadcnStylesheet();

Future<String> _render(ServerTester tester, Widget child) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: _sheet, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

String _tagWithClass(String html, String className) {
  for (final RegExpMatch match in RegExp(
    r'<[^>]+class="([^"]*)"[^>]*>',
  ).allMatches(html)) {
    final List<String> classes = match.group(1)!.split(RegExp(r'\s+'));
    if (classes.contains(className)) {
      return match.group(0)!;
    }
  }
  fail('Missing .$className in rendered HTML');
}

List<String> _tags(String html, String tag) => RegExp(
  '<$tag\\b[^>]*>',
).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();

String get _css => _sheet.componentCss;

void main() {
  group('card family', () {
    testServer('default card uses v4 tokens and the small shadow', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Card(child: Text('Body')),
      );
      final String card = _tagWithClass(html, 'arcane-card');

      expect(card, contains('border-radius: var(--radius-md)'));
      expect(card, contains('border: 1px solid var(--border)'));
      expect(card, contains('background-color: var(--card)'));
      expect(card, contains('color: var(--card-foreground)'));
      expect(card, contains('box-shadow: var(--shadow-sm)'));
      expect(card, contains('padding: 1.5rem'));
      expect(card, isNot(contains('border-radius: 0.5rem')));
    });

    testServer('interactive card exposes CSS hover hooks', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        Card.interactive(onTap: () {}, child: const Text('Open')),
      );
      final String card = _tagWithClass(html, 'arcane-card');

      expect(
        card,
        contains(
          'background-color: var(--shadcn-card-background, var(--card))',
        ),
      );
      expect(
        card,
        contains('box-shadow: var(--shadcn-card-shadow, var(--shadow-sm))'),
      );
      expect(
        _css,
        contains(
          '--shadcn-card-background: '
          'color-mix(in srgb, var(--card) 96%, var(--foreground));',
        ),
      );
      expect(_css, contains('--shadcn-card-shadow: var(--shadow-md);'));
      expect(_css, contains('--shadcn-card-shadow: var(--shadcn-focus-ring);'));
    });

    testServer('flat clickable card stays flat but takes the focus ring', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        Card.flat(onTap: () {}, child: const Text('Open')),
      );
      final String card = _tagWithClass(html, 'arcane-card');

      expect(card, contains('box-shadow: var(--shadcn-card-shadow, none)'));
      expect(
        card,
        contains(
          'background-color: var(--shadcn-card-background, var(--card))',
        ),
      );
      expect(
        _css,
        contains(
          '.arcane-card.clickable:not([data-variant="flat"])'
          ':not([data-variant="outlined"]):not([data-variant="ghost"]):hover',
        ),
      );
    });

    testServer('linked cards share the hover hooks', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Card(href: '/docs', child: Text('Docs')),
      );
      final String card = _tagWithClass(html, 'arcane-card');

      expect(card, startsWith('<a'));
      expect(card, contains('var(--shadcn-card-background, var(--card))'));
    });

    testServer('marketing cards use the radius token and small shadow', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Column(
          children: <Widget>[
            StatCard(label: 'Uptime', value: '99.9%'),
            FeatureCard(title: 'Fast', description: 'Very'),
            CtaCard(title: 'Go', description: 'Now', ctaText: 'Start'),
            TestimonialCard(quote: 'Great', authorName: 'Ada'),
            PricingCard(title: 'Pro', price: r'$9', buttonText: 'Buy'),
            FeatureCard(title: 'Link', description: 'Hover', href: '/x'),
          ],
        ),
      );

      for (final String cls in <String>[
        'arcane-stat-card',
        'arcane-feature-card',
        'arcane-cta-card',
        'arcane-testimonial-card',
        'arcane-pricing-card',
      ]) {
        final String tag = _tagWithClass(html, cls);
        expect(tag, contains('border-radius: var(--radius-md)'), reason: cls);
        expect(tag, isNot(contains('border-radius: 8px')), reason: cls);
        expect(tag, contains('var(--shadow-sm)'), reason: cls);
      }
      final String link = RegExp(
        r'<a[^>]+class="arcane-feature-card"[^>]*>',
      ).firstMatch(html)!.group(0)!;
      expect(link, contains('var(--shadcn-card-background, var(--card))'));
      expect(link, contains('var(--shadcn-card-shadow, var(--shadow-sm))'));
    });

    testServer('flexi cards carry the card surface tokens', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        ArcaneFlexiCardsSimple(
          items: <FlexiCardItem>[
            FlexiCardItem(
              icon: ArcaneIcon.server(),
              shortText: 'Compute',
              longText: 'Managed compute',
            ),
          ],
        ),
      );
      final String card = _tagWithClass(html, 'arcane-flexi-card-simple');

      expect(card, contains('color: var(--card-foreground)'));
      expect(card, contains('box-shadow: var(--shadow-sm)'));
    });
  });

  group('badge', () {
    testServer('solid badges match the v4 badge metrics', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Row(
          children: <Widget>[
            ArcaneStatusBadge.primary('New'),
            ArcaneStatusBadge.outline('Draft'),
            ArcaneStatusBadge.errorSolid('Failed'),
            ArcaneStatusBadge.secondary('Beta'),
          ],
        ),
      );
      final String primary = _tagWithClass(html, 'shadcn-badge-primary');

      for (final String token in <String>[
        'border-radius: var(--radius-sm)',
        'padding: 0.125rem 0.5rem',
        'font-size: 0.75rem',
        'font-weight: 500',
        'line-height: 1rem',
        'gap: 0.25rem',
        'white-space: nowrap',
        'border: 1px solid transparent',
        'background-color: var(--primary)',
        'color: var(--primary-foreground)',
      ]) {
        expect(primary, contains(token), reason: token);
      }

      final String outline = _tagWithClass(html, 'shadcn-badge-outline');
      expect(outline, contains('border: 1px solid var(--border)'));
      expect(outline, contains('color: var(--foreground)'));

      final String destructive = _tagWithClass(html, 'shadcn-badge-errorSolid');
      expect(destructive, contains('background-color: var(--destructive)'));
      expect(destructive, contains('color: var(--destructive-foreground)'));

      final String secondary = _tagWithClass(html, 'shadcn-badge-secondary');
      expect(secondary, contains('background-color: var(--secondary)'));
    });

    testServer('status badges use the badge radius and metrics', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneStatusBadge.success('Online'),
      );
      final String badge = _tagWithClass(html, 'shadcn-status-badge');

      expect(badge, contains('border-radius: var(--radius-sm)'));
      expect(badge, contains('padding: 0.125rem 0.5rem'));
      expect(badge, isNot(contains('border-radius: 4px')));
    });
  });

  group('alert', () {
    testServer('default alert is a neutral card grid', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneAlert.info(title: 'Heads up', message: 'Details'),
      );
      final String alert = _tagWithClass(html, 'arcane-alert');

      for (final String token in <String>[
        'display: grid',
        'grid-template-columns: auto minmax(0, 1fr)',
        'gap: 0.125rem 0.75rem',
        'padding: 0.75rem 1rem',
        'border-radius: var(--radius-md)',
        'border: 1px solid var(--border)',
        'background-color: var(--card)',
        'color: var(--card-foreground)',
        'font-size: 0.875rem',
      ]) {
        expect(alert, contains(token), reason: token);
      }
      expect(alert, isNot(contains('color-mix(in srgb, var(--info')));

      final String title = _tagWithClass(html, 'arcane-alert-title');
      expect(title, contains('font-size: 0.875rem'));
      expect(title, contains('font-weight: 500'));
      expect(title, contains('letter-spacing: -0.01em'));

      final String description = _tagWithClass(
        html,
        'arcane-alert-description',
      );
      expect(description, contains('font-size: 0.875rem'));
      expect(description, contains('color: var(--muted-foreground)'));

      final String icon = _tagWithClass(html, 'arcane-alert-icon');
      expect(icon, contains('color: var(--info)'));
    });

    testServer('destructive alert tints text, not the fill', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneAlert.error(title: 'Failed', message: 'Retry later'),
      );
      final String alert = _tagWithClass(html, 'arcane-alert');

      expect(alert, contains('background-color: var(--card)'));
      expect(alert, contains('color: var(--destructive)'));
      expect(
        _tagWithClass(html, 'arcane-alert-description'),
        contains(
          'color: color-mix(in srgb, var(--destructive) 90%, transparent)',
        ),
      );
    });

    testServer('icon-less alert collapses to one column', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneAlert.info(title: 'Plain', showIcon: false),
      );

      expect(
        _tagWithClass(html, 'arcane-alert'),
        contains('grid-template-columns: minmax(0, 1fr)'),
      );
    });
  });

  group('separator and skeleton', () {
    testServer('separator has no default margin and uses border lines', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Column(
          children: <Widget>[
            ArcaneSeparator(),
            ArcaneSeparator.subtle(),
            ArcaneSeparator(margin: 24),
          ],
        ),
      );
      final List<String> lines = _tags(html, 'hr');

      expect(lines, hasLength(3));
      expect(lines[0], contains('margin: 0 0'));
      expect(lines[0], contains('background-color: var(--border)'));
      expect(lines[0], contains('height: 1px'));
      expect(lines[1], contains('var(--shadcn-subtle-line)'));
      expect(lines[1], isNot(contains('var(--muted)')));
      expect(lines[2], contains('margin: 24.0px 0'));
    });

    testServer('skeleton pulses on the accent surface', (
      ServerTester tester,
    ) async {
      final String html = await _render(tester, const ArcaneSkeleton());
      final String skeleton = _tagWithClass(html, 'arcane-skeleton');

      expect(skeleton, contains('background-color: var(--accent)'));
      expect(skeleton, contains('border-radius: var(--radius-sm)'));
      expect(skeleton, contains('animation: arcane-pulse'));
      expect(_sheet.baseCss, contains('@keyframes arcane-pulse'));
      expect(_css, isNot(contains('@keyframes arcane-shadcn-pulse')));
    });
  });

  group('progress and slider', () {
    testServer('progress track and indicator follow v4', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneProgressBar(value: 0.4),
      );
      final String track = _tagWithClass(html, 'arcane-progress');
      final String indicator = _tagWithClass(html, 'arcane-progress-indicator');

      expect(track, contains('height: 0.5rem'));
      expect(track, contains('border-radius: var(--radius-md)'));
      expect(
        track,
        contains(
          'background-color: color-mix(in srgb, var(--primary) 20%, transparent)',
        ),
      );
      expect(track, contains('overflow: hidden'));
      expect(indicator, contains('background-color: var(--primary)'));
      expect(indicator, contains('border-radius: inherit'));
      expect(indicator, contains('transform: translateX(-60%)'));
      expect(indicator, contains('transition: transform'));
    });

    testServer('indeterminate progress animates with a defined keyframe', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneProgressBar(value: 0, indeterminate: true),
      );

      expect(
        _tagWithClass(html, 'arcane-progress-indicator'),
        contains('animation: arcane-progress-indeterminate'),
      );
      expect(_css, contains('@keyframes arcane-progress-indeterminate'));
    });

    testServer('slider track, range and thumb follow v4', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneSlider(id: 'volume', value: 50),
      );
      final String track = _tagWithClass(html, 'arcane-slider-track');
      final String fill = _tagWithClass(html, 'arcane-slider-track-fill');
      final String thumb = _tagWithClass(html, 'arcane-slider-thumb');

      expect(track, contains('height: 6px'));
      expect(track, contains('border-radius: var(--radius-md)'));
      expect(track, contains('background-color: var(--muted)'));
      expect(fill, contains('background-color: var(--primary)'));
      expect(thumb, contains('width: 16px'));
      expect(thumb, contains('height: 16px'));
      expect(thumb, contains('border: 1px solid var(--primary)'));
      expect(thumb, contains('background-color: var(--background)'));
      expect(thumb, contains('border-radius: 50%'));
      expect(thumb, contains('left: 50.0%'));
      expect(thumb, contains('transform: translate(-50%, -50%)'));
      expect(
        thumb,
        contains(
          'box-shadow: var(--shadcn-slider-thumb-shadow, var(--shadow-sm))',
        ),
      );
      expect(
        _css,
        contains('0 0 0 4px color-mix(in srgb, var(--ring) 50%, transparent)'),
      );
      expect(_css, contains('var(--shadcn-focus-ring)'));
    });
  });

  group('tables', () {
    testServer('data table drops the header fill and uses row hooks', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        DataTable<String>(
          items: const <String>['a', 'b'],
          selectedItems: const <String>{'b'},
          columns: <DataColumn<String>>[
            DataColumn<String>(
              header: 'Name',
              builder: (String item) => Text(item),
            ),
          ],
        ),
      );

      final String head = _tagWithClass(html, 'arcane-data-table-header');
      expect(head, isNot(contains('var(--muted)')));

      final String th = _tags(html, 'th').first;
      for (final String token in <String>[
        'height: 2.5rem',
        'padding: 0 0.5rem',
        'font-weight: 500',
        'color: var(--foreground)',
        'vertical-align: middle',
      ]) {
        expect(th, contains(token), reason: token);
      }

      expect(_tags(html, 'td').first, contains('padding: 0.5rem'));

      final String row = _tagWithClass(html, 'arcane-data-table-row');
      expect(
        row,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      final String selected = _tagWithClass(html, 'selected');
      expect(
        selected,
        contains(
          'background-color: var(--shadcn-item-background, var(--muted))',
        ),
      );
      expect(
        _css,
        contains(
          '--shadcn-item-background: color-mix(in srgb, var(--muted) 50%, transparent);',
        ),
      );
    });

    testServer('static table drops the header fill and uses row hooks', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const StaticTable(
          headers: <String>['Key', 'Value'],
          rows: <List<Widget>>[
            <Widget>[Text('a'), Text('1')],
            <Widget>[Text('b'), Text('2')],
          ],
        ),
      );

      expect(_tags(html, 'thead').first, isNot(contains('var(--muted)')));
      final String th = _tags(html, 'th').first;
      expect(th, contains('height: 2.5rem'));
      expect(th, contains('padding: 0 0.5rem'));
      expect(th, contains('font-weight: 500'));
      expect(
        _tags(html, 'tr')[1],
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      expect(
        _tagWithClass(html, 'arcane-static-table-container'),
        contains('border-radius: var(--radius-md)'),
      );
    });
  });

  group('kbd and avatar', () {
    testServer('default kbd is the flat muted v4 key', (
      ServerTester tester,
    ) async {
      final String html = await _render(tester, const ArcaneKbd('K'));
      final String kbd = _tags(html, 'kbd').first;

      for (final String token in <String>[
        'background: var(--muted)',
        'color: var(--muted-foreground)',
        'height: 1.25rem',
        'min-width: 1.25rem',
        'padding: 0 0.25rem',
        'border-radius: var(--radius-xs)',
        'font-family: var(--font-sans)',
        'font-size: 0.75rem',
        'font-weight: 500',
        'gap: 0.25rem',
        'border: 0',
        'box-shadow: none',
      ]) {
        expect(kbd, contains(token), reason: token);
      }
      expect(kbd, isNot(contains('0 2px 0')));
    });

    testServer('avatar defaults to 32px and never clips its status dot', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Row(
          children: <Widget>[
            ArcaneAvatar(initials: 'AB', showStatus: true),
            ArcaneAvatar(imageUrl: 'a.png', shape: AvatarShape.rounded),
          ],
        ),
      );
      final List<String> roots = RegExp(
        r'<div class="arcane-avatar"[^>]*>',
      ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();

      expect(roots, hasLength(2));
      expect(roots.first, contains('width: 32px'));
      expect(roots.first, contains('height: 32px'));
      expect(roots.first, isNot(contains('overflow: hidden')));
      expect(roots.last, contains('border-radius: var(--radius-md)'));
      expect(html, contains('arcane-avatar-status'));

      final String fallback = _tagWithClass(html, 'arcane-avatar-fallback');
      expect(fallback, contains('font-size: 0.875rem'));
      expect(fallback, contains('background-color: var(--muted)'));
      expect(fallback, contains('border-radius: inherit'));

      final String image = _tags(html, 'img').first;
      expect(image, contains('border-radius: inherit'));
    });
  });

  group('pickers and misc', () {
    testServer('picker triggers use the 36px control height', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        Column(
          children: <Widget>[
            ArcaneDatePicker(id: 'when', value: DateTime(2026, 1, 2)),
            const ArcaneTimePicker(id: 'at'),
          ],
        ),
      );

      final String date = _tagWithClass(html, 'arcane-date-picker-trigger');
      expect(date, contains('height: 36px'));
      expect(date, contains('border-radius: var(--radius-md)'));
      expect(
        date,
        contains('box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))'),
      );
      expect(
        date,
        contains(
          'background-color: var(--shadcn-item-background, var(--background))',
        ),
      );
      expect(
        date,
        contains('color: var(--shadcn-item-foreground, var(--foreground))'),
      );

      final String time = _tagWithClass(html, 'arcane-time-picker-trigger');
      expect(time, contains('height: 36px'));
      expect(time, contains('border-radius: var(--radius-md)'));
      expect(
        time,
        contains(
          'background: var(--shadcn-item-background, var(--background))',
        ),
      );
      expect(
        time,
        contains(
          'color: var(--shadcn-item-foreground, var(--muted-foreground))',
        ),
      );
      expect(
        _css,
        contains('.arcane-date-picker-trigger:hover:not(:disabled)'),
      );
      expect(
        _css,
        contains('.arcane-time-picker-trigger:hover:not(:disabled)'),
      );
    });

    test('display CSS is scoped to the ShadCN root', () {
      final String css = _css;
      for (final String selector in <String>[
        '#arcane-root.arcane-theme-shadcn .arcane-card.clickable:hover',
        '#arcane-root.arcane-theme-shadcn .arcane-data-table-row:hover',
        '#arcane-root.arcane-theme-shadcn .arcane-slider-thumb:hover',
        '#arcane-root.arcane-theme-shadcn .arcane-slider-thumb:focus-visible',
      ]) {
        expect(css, contains(selector), reason: selector);
      }
    });
  });
}
