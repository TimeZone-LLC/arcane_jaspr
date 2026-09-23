import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/html.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;

/// A code block component with syntax highlighting and copy-to-clipboard functionality.
///
/// Displays code in a styled container with a language label and copy button
/// overlaid in the top-right corner.
class CodeBlock extends StatefulWidget {
  final String code;
  final String? language;
  final String? title;

  const CodeBlock({super.key, required this.code, this.language, this.title});

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  void _copyToClipboard() {
    // Clipboard copy is handled by JavaScript via data-code attribute
    // This just updates the visual state
    setState(() => _copied = true);

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasLabel = widget.language != null || widget.title != null;

    // Use raw div() with explicit inline styles to ensure positioning works
    return dom.div(
      styles: const dom.Styles(
        raw: {
          'position': 'relative',
          'margin-bottom': '16px',
          'border-radius': '8px',
          'overflow': 'hidden',
          'background':
              'var(--arcane-code-background, var(--arcane-surface-variant))',
          'border': '1px solid var(--arcane-border)',
        },
      ),
      <jaspr.Component>[
        if (hasLabel)
          dom.div(
            styles: const dom.Styles(
              raw: {
                'position': 'absolute',
                'top': '0',
                'left': '0',
                'padding': '8px 12px',
                'z-index': '1',
              },
            ),
            <jaspr.Component>[
              if (widget.title != null)
                dom.span(
                  styles: const dom.Styles(
                    raw: {'font-size': '12px', 'color': 'var(--arcane-muted)'},
                  ),
                  <jaspr.Component>[jaspr.Component.text(widget.title!)],
                )
              else if (widget.language != null)
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
                  <jaspr.Component>[jaspr.Component.text(widget.language!)],
                ),
            ],
          ),
        dom.div(
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'top': '8px',
              'right': '8px',
              'z-index': '10',
            },
          ),
          <jaspr.Component>[
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
              'max-height': '500px',
              if (hasLabel) 'padding-top': '32px',
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
                  classes: 'language-${widget.language ?? 'dart'}',
                  styles: const dom.Styles(
                    raw: {
                      'font-family': 'var(--font-mono)',
                      'font-size': '13px',
                      'line-height': '1.6',
                    },
                  ),
                  children: <jaspr.Component>[
                    jaspr.Component.text(widget.code),
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

/// Inline code component for short code snippets within text.
class InlineCodeBlock extends StatelessWidget {
  final String code;

  const InlineCodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return ArcaneSpan(
      styles: const ArcaneStyleData(
        fontFamily: FontFamily.mono,
        fontSize: FontSize.sm,
        padding: PaddingPreset.inlineCode,
        background: Background.code,
        borderRadius: Radius.xs,
        textColor: TextColor.accent,
      ),
      child: Text(code),
    );
  }
}
