import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
import 'package:jaspr/dom.dart'
    hide
        Color,
        Colors,
        ColorScheme,
        Gap,
        Padding,
        TextAlign,
        TextOverflow,
        Border,
        BorderRadius,
        BoxShadow,
        FontWeight;

/// Horizontally scrollable widget container.
class CardCarousel extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final String? padding;
  final String? height;

  const CardCarousel({
    super.key,
    this.children = const [],
    this.gap = 16,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return div(
      classes: 'arcane-card-carousel',
      styles: Styles(
        raw: {'position': 'relative', 'width': '100%', 'height': ?height},
      ),
      [
        div(
          classes: 'arcane-card-carousel-content',
          styles: Styles(
            raw: {
              'display': 'flex',
              'gap': '${gap}px',
              'overflow-x': 'auto',
              'overflow-y': 'hidden',
              'scroll-behavior': 'smooth',
              'scrollbar-width': 'none',
              '-ms-overflow-style': 'none',
              'padding': ?padding,
            },
          ),
          children,
        ),
      ],
    );
  }

  @css
  static final List<StyleRule> styles = [
    css(
      '.arcane-card-carousel-content::-webkit-scrollbar',
    ).styles(raw: {'display': 'none'}),
  ];
}

/// Carousel with navigation arrows.
class ArcaneNavigableCarousel extends StatefulWidget {
  final List<Widget> children;
  final double gap;
  final bool showArrows;
  final bool showIndicators;
  final int visibleItems;
  final String? height;

  const ArcaneNavigableCarousel({
    super.key,
    required this.children,
    this.gap = 16,
    this.showArrows = true,
    this.showIndicators = true,
    this.visibleItems = 1,
    this.height,
  });

  @override
  State<ArcaneNavigableCarousel> createState() => _NavigableCarouselState();

  @css
  static final List<StyleRule> styles = [
    css(
      '.arcane-carousel-prev:hover:not([disabled]), .arcane-carousel-next:hover:not([disabled])',
    ).styles(raw: {'background-color': 'var(--muted)'}),
    css(
      '.arcane-carousel-indicators button:hover',
    ).styles(raw: {'background-color': 'var(--accent)', 'opacity': '0.7'}),
  ];
}

class _NavigableCarouselState extends State<ArcaneNavigableCarousel> {
  int _currentIndex = 0;

  int get _maxIndex =>
      (widget.children.length / widget.visibleItems).ceil() - 1;

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < _maxIndex) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _goToIndex(int index) {
    if (index >= 0 && index <= _maxIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int translatePercent = -_currentIndex * 100;

    return div(
      classes: 'arcane-navigable-carousel',
      styles: Styles(
        raw: {
          'position': 'relative',
          'width': '100%',
          if (widget.height != null) 'height': widget.height!,
        },
      ),
      [
        div(
          classes: 'arcane-carousel-viewport',
          styles: const Styles(raw: {'overflow': 'hidden', 'width': '100%'}),
          [
            div(
              classes: 'arcane-carousel-track',
              styles: Styles(
                raw: {
                  'display': 'flex',
                  'gap': '${widget.gap}px',
                  'transform': 'translateX($translatePercent%)',
                  'transition': 'all 200ms ease',
                },
              ),
              [
                for (final child in widget.children)
                  div(
                    styles: Styles(
                      raw: {
                        'flex':
                            '0 0 calc(${100 / widget.visibleItems}% - ${widget.gap * (widget.visibleItems - 1) / widget.visibleItems}px)',
                        'min-width': '0',
                      },
                    ),
                    [child],
                  ),
              ],
            ),
          ],
        ),

        if (widget.showArrows) ...[
          button(
            classes: 'arcane-carousel-prev',
            attributes: {
              'type': 'button',
              'aria-label': 'Previous',
              if (_currentIndex == 0) 'disabled': 'true',
            },
            styles: Styles(
              raw: {
                'position': 'absolute',
                'left': '0.5rem',
                'top': '50%',
                'transform': 'translateY(-50%)',
                'width': '36px',
                'height': '36px',
                'border-radius': 'var(--radius-sm)',
                'border': 'none',
                'background-color': 'var(--card)',
                'color': 'var(--foreground)',
                'cursor': _currentIndex == 0 ? 'not-allowed' : 'pointer',
                'opacity': _currentIndex == 0 ? '0.5' : '1',
                'box-shadow': '0 1px 2px 0 rgb(0 0 0 / 0.05)',
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'center',
                'z-index': '10',
                'transition': 'all 150ms ease',
              },
            ),
            events: {'click': (_) => _goToPrevious()},
            [const Component.text('<')],
          ),

          button(
            classes: 'arcane-carousel-next',
            attributes: {
              'type': 'button',
              'aria-label': 'Next',
              if (_currentIndex >= _maxIndex) 'disabled': 'true',
            },
            styles: Styles(
              raw: {
                'position': 'absolute',
                'right': '0.5rem',
                'top': '50%',
                'transform': 'translateY(-50%)',
                'width': '36px',
                'height': '36px',
                'border-radius': 'var(--radius-sm)',
                'border': 'none',
                'background-color': 'var(--card)',
                'color': 'var(--foreground)',
                'cursor': _currentIndex >= _maxIndex
                    ? 'not-allowed'
                    : 'pointer',
                'opacity': _currentIndex >= _maxIndex ? '0.5' : '1',
                'box-shadow': '0 1px 2px 0 rgb(0 0 0 / 0.05)',
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'center',
                'z-index': '10',
                'transition': 'all 150ms ease',
              },
            ),
            events: {'click': (_) => _goToNext()},
            [const Component.text('>')],
          ),
        ],

        if (widget.showIndicators && _maxIndex > 0)
          div(
            classes: 'arcane-carousel-indicators',
            styles: const Styles(
              raw: {
                'display': 'flex',
                'justify-content': 'center',
                'gap': '0.5rem',
                'margin-top': '1.5rem',
              },
            ),
            [
              for (int i = 0; i <= _maxIndex; i++)
                button(
                  attributes: {
                    'type': 'button',
                    'aria-label': 'Go to slide ${i + 1}',
                  },
                  styles: Styles(
                    raw: {
                      'width': i == _currentIndex ? '24px' : '8px',
                      'height': '8px',
                      'border-radius': '0.25rem',
                      'border': 'none',
                      'background-color': i == _currentIndex
                          ? 'var(--accent)'
                          : 'var(--border)',
                      'cursor': 'pointer',
                      'transition': 'all 150ms ease',
                      'padding': '0',
                    },
                  ),
                  events: {'click': (_) => _goToIndex(i)},
                  [],
                ),
            ],
          ),
      ],
    );
  }
}

/// Hero carousel with full-width slides.
class ArcaneHeroCarousel extends StatefulWidget {
  final List<Widget> children;
  final int autoPlayInterval;
  final bool showArrows;
  final bool showIndicators;
  final String height;

  const ArcaneHeroCarousel({
    super.key,
    required this.children,
    this.autoPlayInterval = 5000,
    this.showArrows = true,
    this.showIndicators = true,
    this.height = '400px',
  });

  @override
  State<ArcaneHeroCarousel> createState() => _HeroCarouselState();

  @css
  static final List<StyleRule> styles = [
    css(
      '.arcane-hero-carousel button:hover',
    ).styles(raw: {'background-color': 'rgba(0, 0, 0, 0.6)'}),
  ];
}

class _HeroCarouselState extends State<ArcaneHeroCarousel> {
  int _currentIndex = 0;

  void _goToPrevious() {
    setState(() {
      _currentIndex = _currentIndex == 0
          ? widget.children.length - 1
          : _currentIndex - 1;
    });
  }

  void _goToNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.children.length;
    });
  }

  void _goToIndex(int index) {
    if (index >= 0 && index < widget.children.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return div(
      classes: 'arcane-hero-carousel',
      styles: Styles(
        raw: {
          'position': 'relative',
          'width': '100%',
          'height': widget.height,
          'overflow': 'hidden',
        },
      ),
      [
        for (int i = 0; i < widget.children.length; i++)
          div(
            classes: 'arcane-hero-slide',
            styles: Styles(
              raw: {
                'position': 'absolute',
                'inset': '0',
                'opacity': i == _currentIndex ? '1' : '0',
                'visibility': i == _currentIndex ? 'visible' : 'hidden',
                'transition': 'opacity 500ms ease, visibility 500ms ease',
              },
            ),
            [widget.children[i]],
          ),

        if (widget.showArrows && widget.children.length > 1) ...[
          button(
            attributes: {'type': 'button', 'aria-label': 'Previous'},
            styles: const Styles(
              raw: {
                'position': 'absolute',
                'left': '1.5rem',
                'top': '50%',
                'transform': 'translateY(-50%)',
                'width': '48px',
                'height': '48px',
                'border-radius': 'var(--radius-sm)',
                'border': 'none',
                'background-color': 'rgba(0, 0, 0, 0.4)',
                'color': 'white',
                'cursor': 'pointer',
                'font-size': '1.25rem',
                'z-index': '10',
                'transition': 'all 150ms ease',
              },
            ),
            events: {'click': (_) => _goToPrevious()},
            [const Component.text('<')],
          ),
          button(
            attributes: {'type': 'button', 'aria-label': 'Next'},
            styles: const Styles(
              raw: {
                'position': 'absolute',
                'right': '1.5rem',
                'top': '50%',
                'transform': 'translateY(-50%)',
                'width': '48px',
                'height': '48px',
                'border-radius': 'var(--radius-sm)',
                'border': 'none',
                'background-color': 'rgba(0, 0, 0, 0.4)',
                'color': 'white',
                'cursor': 'pointer',
                'font-size': '1.25rem',
                'z-index': '10',
                'transition': 'all 150ms ease',
              },
            ),
            events: {'click': (_) => _goToNext()},
            [const Component.text('>')],
          ),
        ],

        if (widget.showIndicators && widget.children.length > 1)
          div(
            styles: const Styles(
              raw: {
                'position': 'absolute',
                'bottom': '1.5rem',
                'left': '50%',
                'transform': 'translateX(-50%)',
                'display': 'flex',
                'gap': '0.5rem',
                'z-index': '10',
              },
            ),
            [
              for (int i = 0; i < widget.children.length; i++)
                button(
                  attributes: {
                    'type': 'button',
                    'aria-label': 'Go to slide ${i + 1}',
                  },
                  styles: Styles(
                    raw: {
                      'width': '12px',
                      'height': '12px',
                      'border-radius': '2px',
                      'border': '2px solid white',
                      'background-color': i == _currentIndex
                          ? 'white'
                          : 'transparent',
                      'cursor': 'pointer',
                      'transition': 'all 150ms ease',
                      'padding': '0',
                    },
                  ),
                  events: {'click': (_) => _goToIndex(i)},
                  [],
                ),
            ],
          ),
      ],
    );
  }
}
