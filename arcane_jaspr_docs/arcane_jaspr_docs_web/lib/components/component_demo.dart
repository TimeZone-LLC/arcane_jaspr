import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/html.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;

/// A wrapper component that displays a live component demo alongside its code.
///
/// Use this to show users what a component looks like and how to implement it.
class ComponentDemo extends StatelessWidget {
  /// The title of the demo (optional)
  final String? title;

  /// Description of the demo (optional)
  final String? description;

  /// The live component to render
  final Widget child;

  /// The code that produces the component
  final String code;

  /// The programming language for syntax highlighting
  final String language;

  /// Background style for the preview area
  final DemoBackground background;

  /// Padding around the preview component
  final PaddingPreset padding;

  const ComponentDemo({
    super.key,
    this.title,
    this.description,
    required this.child,
    required this.code,
    this.language = 'dart',
    this.background = DemoBackground.default_,
    this.padding = PaddingPreset.lg,
  });

  @override
  Widget build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomXl,
        borderRadius: Radius.md,
        overflow: Overflow.hidden,
        border: BorderPreset.standard,
      ),
      children: [
        if (title != null || description != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              padding: PaddingPreset.md,
              background: Background.backgroundSecondary,
              border: BorderPreset.standard,
            ),
            children: [
              if (title != null)
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontWeight: FontWeight.w600,
                    fontSize: FontSize.base,
                    textColor: TextColor.primary,
                    margin: MarginPreset.bottomXs,
                  ),
                  children: [Text(title!)],
                ),
              if (description != null)
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.sm,
                    textColor: TextColor.mutedForeground,
                  ),
                  children: [Text(description!)],
                ),
            ],
          ),
        ArcaneDiv(
          styles: ArcaneStyleData(
            padding: padding,
            display: Display.flex,
            alignItems: AlignItems.center,
            justifyContent: JustifyContent.center,
            minHeight: '120px',
            backgroundCustom: background.css,
          ),
          children: [child],
        ),
        ArcaneDiv(
          styles: const ArcaneStyleData(border: BorderPreset.standard),
          children: [_DemoCodeBlock(code: code, language: language)],
        ),
      ],
    );
  }
}

/// Internal code block without margins for use in ComponentDemo
class _DemoCodeBlock extends StatefulWidget {
  final String code;
  final String language;

  const _DemoCodeBlock({required this.code, required this.language});

  @override
  State<_DemoCodeBlock> createState() => _DemoCodeBlockState();
}

class _DemoCodeBlockState extends State<_DemoCodeBlock> {
  bool _expanded = false;
  bool _copied = false;

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  void _copyToClipboard() {
    // Clipboard copy is handled by JavaScript via data-code attribute
    // This just updates the visual state
    setState(() => _copied = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> lines = widget.code.split('\n');
    bool isLong = lines.length > 10;
    String displayCode = _expanded || !isLong
        ? widget.code
        : '${lines.take(10).join('\n')}\n...';

    // Use raw div() with explicit inline styles to ensure positioning works
    return dom.div(
      styles: const dom.Styles(
        raw: {
          'position': 'relative',
          'background':
              'var(--arcane-code-background, var(--arcane-surface-variant))',
        },
      ),
      <jaspr.Component>[
        dom.div(
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'top': '8px',
              'right': '8px',
              'z-index': '10',
              'display': 'flex',
              'align-items': 'center',
              'gap': '8px',
            },
          ),
          <jaspr.Component>[
            dom.span(
              styles: const dom.Styles(
                raw: {
                  'font-size': '11px',
                  'color': 'var(--arcane-muted)',
                  'padding': '2px 8px',
                  'background': 'rgba(255,255,255,0.1)',
                  'border-radius': '4px',
                },
              ),
              <jaspr.Component>[jaspr.Component.text(widget.language)],
            ),
            if (isLong)
              dom.button(
                styles: dom.Styles(
                  raw: {
                    'display': 'flex',
                    'align-items': 'center',
                    'justify-content': 'center',
                    'width': '28px',
                    'height': '28px',
                    'padding': '0',
                    'border': 'none',
                    'background': 'transparent',
                    'color': 'var(--arcane-muted)',
                    'cursor': 'pointer',
                    'border-radius': '4px',
                  },
                ),
                events: {'click': (_) => _toggleExpanded()},
                <jaspr.Component>[
                  _expanded
                      ? ArcaneIcon.minimize2(size: IconSize.sm)
                      : ArcaneIcon.maximize2(size: IconSize.sm),
                ],
              ),
            dom.button(
              attributes: {'data-code': widget.code},
              styles: dom.Styles(
                raw: {
                  'display': 'flex',
                  'align-items': 'center',
                  'justify-content': 'center',
                  'width': '28px',
                  'height': '28px',
                  'padding': '0',
                  'border': 'none',
                  'background': 'transparent',
                  'color': _copied
                      ? 'var(--arcane-success)'
                      : 'var(--arcane-muted)',
                  'cursor': 'pointer',
                  'border-radius': '4px',
                },
              ),
              events: {'click': (_) => _copyToClipboard()},
              <jaspr.Component>[
                _copied
                    ? ArcaneIcon.check(size: IconSize.sm)
                    : ArcaneIcon.copy(size: IconSize.sm),
              ],
            ),
          ],
        ),
        dom.div(
          styles: dom.Styles(
            raw: {
              'overflow': 'auto',
              'max-height': _expanded ? 'none' : '300px',
              'padding-top': '40px',
            },
          ),
          <jaspr.Component>[
            jaspr.Component.element(
              tag: 'pre',
              styles: const dom.Styles(
                raw: {
                  'margin': '0',
                  'padding': '16px',
                  'background': 'transparent',
                  'overflow': 'auto',
                },
              ),
              children: <jaspr.Component>[
                jaspr.Component.element(
                  tag: 'code',
                  classes: 'language-${widget.language}',
                  styles: const dom.Styles(
                    raw: {
                      'font-family': 'var(--font-mono)',
                      'font-size': '13px',
                      'line-height': '1.6',
                    },
                  ),
                  children: <jaspr.Component>[
                    jaspr.Component.text(displayCode),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Background styles for the demo preview area
enum DemoBackground {
  default_('var(--arcane-background-secondary)'),
  dark('var(--arcane-background)'),
  light('var(--arcane-surface)'),
  transparent('transparent'),
  checkered(
    'repeating-conic-gradient(var(--arcane-surface-variant) 0% 25%, var(--arcane-surface) 0% 50%) 50% / 20px 20px',
  );

  final String css;
  const DemoBackground(this.css);
}

/// A simple demo component for showing multiple variants in a row
class ComponentDemoRow extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final Gap gap;

  const ComponentDemoRow({
    super.key,
    this.title,
    required this.children,
    this.gap = Gap.md,
  });

  @override
  Widget build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(margin: MarginPreset.bottomLg),
      children: [
        if (title != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              fontWeight: FontWeight.w600,
              fontSize: FontSize.sm,
              textColor: TextColor.mutedForeground,
              margin: MarginPreset.bottomSm,
            ),
            children: [Text(title!)],
          ),
        ArcaneDiv(
          styles: ArcaneStyleData(
            display: Display.flex,
            flexWrap: FlexWrap.wrap,
            alignItems: AlignItems.center,
            gap: gap,
            padding: PaddingPreset.lg,
            borderRadius: Radius.md,
            background: Background.backgroundSecondary,
            border: BorderPreset.standard,
          ),
          children: children,
        ),
      ],
    );
  }
}
