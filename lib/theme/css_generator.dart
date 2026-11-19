import 'control_config.dart';
import 'font_config.dart';
import 'motion_config.dart';
import 'palette.dart';
import 'palette_generator.dart';
import 'radius_config.dart';

/// Generates CSS variable blocks from [ThemePalette].
abstract class CssGenerator {
  CssGenerator._();

  /// Generate CSS variables for a single palette.
  ///
  /// [selector] is the CSS selector (`:root` or `.dark`).
  static String generate(
    ThemePalette palette, {
    String selector = ':root',
    FontConfig fonts = const FontConfig(),
    RadiusConfig radius = const RadiusConfig(),
    ControlConfig controls = const ControlConfig(),
    MotionConfig motion = const MotionConfig(),
    bool includeStatic = true,
  }) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('$selector {');

    // Core colors
    _writeColor(buffer, 'background', palette.background);
    _writeColor(buffer, 'foreground', palette.foreground);
    buffer.writeln();

    // Card / Popover
    _writeColor(buffer, 'card', palette.card);
    _writeColor(buffer, 'card-foreground', palette.cardForeground);
    _writeColor(buffer, 'card-hover', palette.cardHover);
    _writeColor(buffer, 'popover', palette.popover);
    _writeColor(buffer, 'popover-foreground', palette.popoverForeground);
    buffer.writeln();

    // Primary
    _writeColor(buffer, 'primary', palette.primary);
    _writeColor(buffer, 'primary-foreground', palette.primaryForeground);
    _writeColor(buffer, 'primary-container', palette.primaryContainer);
    buffer.writeln();

    // Secondary
    _writeColor(buffer, 'secondary', palette.secondary);
    _writeColor(buffer, 'secondary-foreground', palette.secondaryForeground);
    _writeColor(buffer, 'secondary-container', palette.secondaryContainer);
    buffer.writeln();

    // Accent
    _writeColor(buffer, 'accent', palette.accent);
    _writeColor(buffer, 'accent-foreground', palette.accentForeground);
    _writeColor(buffer, 'accent-hover', palette.accentHover);
    _writeColor(buffer, 'accent-container', palette.accentContainer);
    buffer.writeln();

    // Muted
    _writeColor(buffer, 'muted', palette.muted);
    _writeColor(buffer, 'muted-foreground', palette.mutedForeground);
    buffer.writeln();

    // Destructive
    _writeColor(buffer, 'destructive', palette.destructive);
    _writeColor(
      buffer,
      'destructive-foreground',
      palette.destructiveForeground,
    );
    _writeColor(buffer, 'destructive-hover', palette.destructiveHover);
    _writeColor(buffer, 'destructive-container', palette.destructiveContainer);
    buffer.writeln();

    // Success
    _writeColor(buffer, 'success', palette.success);
    _writeColor(buffer, 'success-foreground', palette.successForeground);
    _writeColor(buffer, 'success-hover', palette.successHover);
    _writeColor(buffer, 'success-container', palette.successContainer);
    buffer.writeln();

    // Warning
    _writeColor(buffer, 'warning', palette.warning);
    _writeColor(buffer, 'warning-foreground', palette.warningForeground);
    _writeColor(buffer, 'warning-hover', palette.warningHover);
    _writeColor(buffer, 'warning-container', palette.warningContainer);
    buffer.writeln();

    // Info
    _writeColor(buffer, 'info', palette.info);
    _writeColor(buffer, 'info-foreground', palette.infoForeground);
    _writeColor(buffer, 'info-hover', palette.infoHover);
    _writeColor(buffer, 'info-container', palette.infoContainer);
    buffer.writeln();

    // Borders
    _writeColor(buffer, 'border', palette.border);
    _writeColor(buffer, 'input', palette.input);
    _writeColor(buffer, 'ring', palette.ring);
    buffer.writeln();

    // Overlays
    _writeRgba(buffer, 'overlay', palette.overlay);
    _writeRgba(buffer, 'navbar', palette.navbar);
    _writeColor(buffer, 'code-background', palette.codeBackground);
    buffer.writeln();

    // RGB values for compositing
    _writeRgb(buffer, 'background-rgb', palette.background);
    _writeRgb(buffer, 'foreground-rgb', palette.foreground);
    _writeRgb(buffer, 'primary-rgb', palette.primary);
    _writeRgb(buffer, 'secondary-rgb', palette.secondary);
    _writeRgb(buffer, 'accent-rgb', palette.accent);
    _writeRgb(buffer, 'muted-rgb', palette.mutedForeground);
    _writeRgb(buffer, 'destructive-rgb', palette.destructive);
    _writeRgb(buffer, 'success-rgb', palette.success);
    _writeRgb(buffer, 'warning-rgb', palette.warning);
    _writeRgb(buffer, 'info-rgb', palette.info);
    _writeRgb(buffer, 'card-rgb', palette.card);
    _writeRgb(buffer, 'border-rgb', palette.border);
    buffer.writeln();

    // Shadows
    buffer.writeln('  --shadow-xs: ${palette.shadowXs};');
    buffer.writeln('  --shadow-sm: ${palette.shadowSm};');
    buffer.writeln('  --shadow-md: ${palette.shadowMd};');
    buffer.writeln('  --shadow-lg: ${palette.shadowLg};');
    buffer.writeln('  --shadow-xl: ${palette.shadowXl};');
    buffer.writeln();

    // Static values (only for :root, not .dark)
    if (includeStatic) {
      // Typography
      buffer.writeln("  --font-sans: ${fonts.sans};");
      buffer.writeln("  --font-heading: ${fonts.headingOrSans};");
      buffer.writeln("  --font-mono: ${fonts.mono};");
      buffer.writeln();

      // Radius
      buffer.writeln('  --radius: ${radius.md};');
      buffer.writeln('  --radius-xs: ${radius.xs};');
      buffer.writeln('  --radius-sm: ${radius.sm};');
      buffer.writeln('  --radius-md: ${radius.md};');
      buffer.writeln();

      // Form controls and buttons
      buffer.writeln('  --control-height-sm: ${controls.heightSm};');
      buffer.writeln('  --control-height-md: ${controls.heightMd};');
      buffer.writeln('  --control-height-lg: ${controls.heightLg};');
      buffer.writeln('  --control-padding-x: ${controls.paddingX};');
      buffer.writeln('  --control-font-size: ${controls.fontSize};');
      buffer.writeln('  --control-label-gap: ${controls.labelGap};');
      buffer.writeln();

      // Spacing scale
      buffer.writeln('  --space-0: 0;');
      buffer.writeln('  --space-px: 1px;');
      buffer.writeln('  --space-0-5: 0.125rem;');
      buffer.writeln('  --space-1: 0.25rem;');
      buffer.writeln('  --space-1-5: 0.375rem;');
      buffer.writeln('  --space-2: 0.5rem;');
      buffer.writeln('  --space-2-5: 0.625rem;');
      buffer.writeln('  --space-3: 0.75rem;');
      buffer.writeln('  --space-3-5: 0.875rem;');
      buffer.writeln('  --space-4: 1rem;');
      buffer.writeln('  --space-5: 1.25rem;');
      buffer.writeln('  --space-6: 1.5rem;');
      buffer.writeln('  --space-7: 1.75rem;');
      buffer.writeln('  --space-8: 2rem;');
      buffer.writeln('  --space-9: 2.25rem;');
      buffer.writeln('  --space-10: 2.5rem;');
      buffer.writeln('  --space-12: 3rem;');
      buffer.writeln('  --space-14: 3.5rem;');
      buffer.writeln('  --space-16: 4rem;');
      buffer.writeln('  --space-20: 5rem;');
      buffer.writeln('  --space-24: 6rem;');
      buffer.writeln('  --space-32: 8rem;');
      buffer.writeln();

      // Font sizes
      buffer.writeln('  --font-size-xs: 0.75rem;');
      buffer.writeln('  --font-size-sm: 0.875rem;');
      buffer.writeln('  --font-size-base: 1rem;');
      buffer.writeln('  --font-size-lg: 1.125rem;');
      buffer.writeln('  --font-size-xl: 1.25rem;');
      buffer.writeln('  --font-size-2xl: 1.5rem;');
      buffer.writeln('  --font-size-3xl: 1.875rem;');
      buffer.writeln('  --font-size-4xl: 2.25rem;');
      buffer.writeln('  --font-size-5xl: 3rem;');
      buffer.writeln();

      // Font weights
      buffer.writeln('  --font-weight-normal: 400;');
      buffer.writeln('  --font-weight-medium: 500;');
      buffer.writeln('  --font-weight-semibold: 600;');
      buffer.writeln('  --font-weight-bold: 700;');
      buffer.writeln();

      // Transitions
      buffer.writeln('  --transition-fast: ${motion.fast};');
      buffer.writeln('  --transition: ${motion.base};');
      buffer.writeln('  --transition-slow: ${motion.slow};');
      buffer.writeln('  --transition-slower: ${motion.slower};');
      buffer.writeln();

      buffer.writeln('  --arcane-background: var(--background);');
      buffer.writeln('  --arcane-background-secondary: var(--muted);');
      buffer.writeln('  --arcane-background-tertiary: var(--secondary);');
      buffer.writeln('  --arcane-surface: var(--card);');
      buffer.writeln('  --arcane-surface-variant: var(--secondary);');
      buffer.writeln('  --arcane-card: var(--card);');
      buffer.writeln('  --arcane-card-hover: var(--card-hover);');
      buffer.writeln('  --arcane-card-alt: var(--secondary);');
      buffer.writeln('  --arcane-input: var(--input);');
      buffer.writeln('  --arcane-popover: var(--popover);');
      buffer.writeln('  --arcane-navbar: var(--navbar);');
      buffer.writeln();

      buffer.writeln('  --arcane-primary: var(--primary);');
      buffer.writeln('  --arcane-secondary: var(--secondary);');
      buffer.writeln('  --arcane-accent: var(--accent);');
      buffer.writeln('  --arcane-muted: var(--muted);');
      buffer.writeln();

      buffer.writeln('  --arcane-foreground: var(--foreground);');
      buffer.writeln('  --arcane-on-background: var(--foreground);');
      buffer.writeln('  --arcane-on-surface: var(--card-foreground);');
      buffer.writeln('  --arcane-card-foreground: var(--card-foreground);');
      buffer.writeln('  --arcane-muted-foreground: var(--muted-foreground);');
      buffer.writeln('  --arcane-text-subtle: var(--muted-foreground);');
      buffer.writeln(
        '  --arcane-text-faint: color-mix(in srgb, var(--muted-foreground) 60%, transparent);',
      );
      buffer.writeln(
        '  --arcane-primary-foreground: var(--primary-foreground);',
      );
      buffer.writeln(
        '  --arcane-secondary-foreground: var(--secondary-foreground);',
      );
      buffer.writeln('  --arcane-accent-foreground: var(--accent-foreground);');
      buffer.writeln();

      buffer.writeln('  --arcane-border: var(--border);');
      buffer.writeln('  --arcane-border-subtle: var(--input);');
      buffer.writeln('  --arcane-border-medium: var(--border);');
      buffer.writeln(
        '  --arcane-border-light: color-mix(in srgb, var(--border) 50%, transparent);',
      );
      buffer.writeln('  --arcane-ring: var(--ring);');
      buffer.writeln();

      buffer.writeln('  --arcane-success: var(--success);');
      buffer.writeln(
        '  --arcane-success-foreground: var(--success-foreground);',
      );
      buffer.writeln('  --arcane-warning: var(--warning);');
      buffer.writeln(
        '  --arcane-warning-foreground: var(--warning-foreground);',
      );
      buffer.writeln('  --arcane-error: var(--destructive);');
      buffer.writeln(
        '  --arcane-error-foreground: var(--destructive-foreground);',
      );
      buffer.writeln('  --arcane-destructive: var(--destructive);');
      buffer.writeln(
        '  --arcane-destructive-foreground: var(--destructive-foreground);',
      );
      buffer.writeln('  --arcane-info: var(--info);');
      buffer.writeln('  --arcane-info-foreground: var(--info-foreground);');
      buffer.writeln();

      buffer.writeln('  --arcane-tooltip: var(--popover);');
      buffer.writeln(
        '  --arcane-tooltip-foreground: var(--popover-foreground);',
      );
      buffer.writeln('  --arcane-code-background: var(--code-background);');
      buffer.writeln();

      buffer.writeln('  --arcane-background-rgb: var(--background-rgb);');
      buffer.writeln('  --arcane-foreground-rgb: var(--foreground-rgb);');
      buffer.writeln('  --arcane-primary-rgb: var(--primary-rgb);');
      buffer.writeln('  --arcane-secondary-rgb: var(--secondary-rgb);');
      buffer.writeln('  --arcane-accent-rgb: var(--accent-rgb);');
      buffer.writeln('  --arcane-muted-rgb: var(--muted-rgb);');
      buffer.writeln('  --arcane-destructive-rgb: var(--destructive-rgb);');
      buffer.writeln('  --arcane-success-rgb: var(--success-rgb);');
      buffer.writeln('  --arcane-warning-rgb: var(--warning-rgb);');
      buffer.writeln('  --arcane-info-rgb: var(--info-rgb);');
      buffer.writeln('  --arcane-card-rgb: var(--card-rgb);');
      buffer.writeln('  --arcane-border-rgb: var(--border-rgb);');
      buffer.writeln();

      buffer.writeln('  --arcane-shadow-xs: var(--shadow-xs);');
      buffer.writeln('  --arcane-shadow-sm: var(--shadow-sm);');
      buffer.writeln('  --arcane-shadow-md: var(--shadow-md);');
      buffer.writeln('  --arcane-shadow-lg: var(--shadow-lg);');
      buffer.writeln('  --arcane-shadow-xl: var(--shadow-xl);');
      buffer.writeln();

      buffer.writeln('  --arcane-radius: var(--radius);');
      buffer.writeln('  --arcane-radius-xs: var(--radius-xs);');
      buffer.writeln('  --arcane-radius-sm: var(--radius-sm);');
      buffer.writeln('  --arcane-radius-md: var(--radius-md);');
      buffer.writeln();

      buffer.writeln('  --arcane-font-sans: var(--font-sans);');
      buffer.writeln('  --arcane-font-heading: var(--font-heading);');
      buffer.writeln('  --arcane-font-mono: var(--font-mono);');
      buffer.writeln('  --arcane-font-size-xs: var(--font-size-xs);');
      buffer.writeln('  --arcane-font-size-sm: var(--font-size-sm);');
      buffer.writeln('  --arcane-font-size-base: var(--font-size-base);');
      buffer.writeln('  --arcane-font-size-lg: var(--font-size-lg);');
      buffer.writeln('  --arcane-font-size-xl: var(--font-size-xl);');
      buffer.writeln('  --arcane-font-size-2xl: var(--font-size-2xl);');
      buffer.writeln('  --arcane-font-size-3xl: var(--font-size-3xl);');
      buffer.writeln('  --arcane-font-size-4xl: var(--font-size-4xl);');
      buffer.writeln('  --arcane-font-size-5xl: var(--font-size-5xl);');
      buffer.writeln(
        '  --arcane-font-weight-normal: var(--font-weight-normal);',
      );
      buffer.writeln(
        '  --arcane-font-weight-medium: var(--font-weight-medium);',
      );
      buffer.writeln(
        '  --arcane-font-weight-semibold: var(--font-weight-semibold);',
      );
      buffer.writeln('  --arcane-font-weight-bold: var(--font-weight-bold);');
      buffer.writeln();

      buffer.writeln('  --arcane-space-0: var(--space-0);');
      buffer.writeln('  --arcane-space-px: var(--space-px);');
      buffer.writeln('  --arcane-space-0-5: var(--space-0-5);');
      buffer.writeln('  --arcane-space-1: var(--space-1);');
      buffer.writeln('  --arcane-space-1-5: var(--space-1-5);');
      buffer.writeln('  --arcane-space-2: var(--space-2);');
      buffer.writeln('  --arcane-space-2-5: var(--space-2-5);');
      buffer.writeln('  --arcane-space-3: var(--space-3);');
      buffer.writeln('  --arcane-space-3-5: var(--space-3-5);');
      buffer.writeln('  --arcane-space-4: var(--space-4);');
      buffer.writeln('  --arcane-space-5: var(--space-5);');
      buffer.writeln('  --arcane-space-6: var(--space-6);');
      buffer.writeln('  --arcane-space-7: var(--space-7);');
      buffer.writeln('  --arcane-space-8: var(--space-8);');
      buffer.writeln('  --arcane-space-9: var(--space-9);');
      buffer.writeln('  --arcane-space-10: var(--space-10);');
      buffer.writeln('  --arcane-space-12: var(--space-12);');
      buffer.writeln('  --arcane-space-14: var(--space-14);');
      buffer.writeln('  --arcane-space-16: var(--space-16);');
      buffer.writeln('  --arcane-space-20: var(--space-20);');
      buffer.writeln('  --arcane-space-24: var(--space-24);');
      buffer.writeln('  --arcane-space-32: var(--space-32);');
      buffer.writeln();

      buffer.writeln('  --arcane-transition-fast: var(--transition-fast);');
      buffer.writeln('  --arcane-transition: var(--transition);');
      buffer.writeln('  --arcane-transition-slow: var(--transition-slow);');
      buffer.writeln('  --arcane-transition-slower: var(--transition-slower);');
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  /// Generate CSS for both light and dark mode.
  static String generateBoth({
    required ThemePalette light,
    required ThemePalette dark,
    FontConfig fonts = const FontConfig(),
    RadiusConfig radius = const RadiusConfig(),
    ControlConfig controls = const ControlConfig(),
    MotionConfig motion = const MotionConfig(),
  }) {
    final StringBuffer buffer = StringBuffer();

    // Light mode (includes static values)
    // Use both :root and html.light so variables work for:
    // - Default/fallback (:root)
    // - Document-level scrollbars when light class is on html (html.light)
    buffer.writeln(
      generate(
        light,
        selector: ':root, html.light, .light',
        fonts: fonts,
        radius: radius,
        controls: controls,
        motion: motion,
        includeStatic: true,
      ),
    );

    buffer.writeln();

    // Dark mode (no static values, they inherit from :root)
    // Use both html.dark and .dark so variables work for:
    // - Document-level scrollbars (html.dark)
    // - Component-level styling (.dark on #arcane-root)
    buffer.writeln(
      generate(
        dark,
        selector: 'html.dark, .dark',
        fonts: fonts,
        radius: radius,
        includeStatic: false,
      ),
    );

    return buffer.toString();
  }

  // ============================================
  // Helper Methods
  // ============================================

  static void _writeColor(StringBuffer buffer, String name, int color) {
    buffer.writeln('  --$name: ${PaletteGenerator.toHex(color)};');
  }

  static void _writeRgb(StringBuffer buffer, String name, int color) {
    buffer.writeln('  --$name: ${PaletteGenerator.toRgbString(color)};');
  }

  static void _writeRgba(StringBuffer buffer, String name, int color) {
    buffer.writeln('  --$name: ${PaletteGenerator.toRgba(color)};');
  }
}
