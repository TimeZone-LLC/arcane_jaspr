import 'package:arcane_jaspr/core/rendering/base/drawer_render_base.dart';

/// Neubrutalism Drawer renderer.
///
/// Implements the Neubrutalism design language:
/// - Flat high-contrast surface
/// - Complete neutral perimeter
/// - OLED-optimized dark background
class NeubrutalismDrawer extends DrawerRenderBase {
  const NeubrutalismDrawer(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  String get positionBorder =>
      'var(--nb-border-thin, 2px) solid var(--nb-line, #000)';

  @override
  Map<String, String> get overlayBackdropStyles => <String, String>{
    'background-color': 'rgba(0, 0, 0, 0.55)',
  };

  @override
  Map<String, String> get panelDecorationStyles => <String, String>{
    'box-sizing': 'border-box',
    'max-width': '100%',
    'max-height': '100%',
    'min-width': '0',
    'background': 'var(--nb-paper, var(--card))',
    'box-shadow':
        'var(--nb-shadow-lg, 7px 7px 0 0 var(--nb-shadow-color, #000))',
    'overflow': 'hidden',
  };

  @override
  String get headerFooterBorder =>
      'var(--nb-border-thin, 2px) solid var(--nb-line, #000)';

  @override
  Map<String, String> get closeButtonStyles => <String, String>{
    'width': '44px',
    'height': '44px',
    'flex-shrink': '0',
    'display': 'flex',
    'align-items': 'center',
    'justify-content': 'center',
    'background': 'transparent',
    'border': 'none',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'color': 'var(--muted-foreground)',
    'cursor': 'pointer',
    'transition': 'color 0.15s ease, background 0.15s ease',
  };

  static int _autoCounter = 0;

  @override
  String generateAutoId() {
    _autoCounter++;
    return 'neubrutalism-drawer-$_autoCounter';
  }
}
