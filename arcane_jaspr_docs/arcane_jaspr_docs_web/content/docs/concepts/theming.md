---
title: Theming
description: Learn how to configure stylesheets and theming in Arcane Jaspr
layout: kb
component: theming
---

# Theming

Arcane Jaspr uses a stylesheet-based theming system built on CSS custom properties. Stylesheets provide complete design systems including colors, typography, spacing, and component renderers.

## ArcaneApp

Every Arcane application must be wrapped in an `ArcaneApp` component which provides the theme context and injects the stylesheet CSS.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  brightness: Brightness.dark,
  home: YourApp(),
)
```

## Available Stylesheets

Arcane Jaspr keeps the Flutter-like authoring surface in `package:arcane_jaspr` and ships concrete stylesheets as renderer packages:

| Stylesheet | Description |
|------------|-------------|
| `arcane_jaspr_ascii` / `AsciiStylesheet` | Paper and ink palettes, drawn datum lines, terminal typography, and character-based motion. [Explore Ascii](/ascii). |
| `arcane_jaspr_shadcn` / `ShadcnStylesheet` | Quiet document/app chrome with compact spacing, subtle borders, and shadcn-style controls |
| `arcane_jaspr_neon` / `NeonStylesheet` | Command/workbench chrome with stronger contrast, denser shell treatment, larger controls, and bolder radius |
| `arcane_jaspr_neubrutalism` / `NeubrutalismStylesheet` | Comic-book pop-art chrome with thick black borders, hard-offset shadows, flat saturated colors, and press-down click feedback |

```dart
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  home: MyApp(),
)
```

```dart
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';

ArcaneApp(
  stylesheet: const NeonStylesheet(),
  home: MyApp(),
)
```

```dart
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';

ArcaneApp(
  stylesheet: const NeubrutalismStylesheet(theme: NeubrutalismTheme.yellow),
  home: MyApp(),
)
```

## Brightness Mode

Control light/dark mode with the `brightness` parameter:

```dart
ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  brightness: Brightness.dark,
  home: MyApp(),
)
```

| Value | Description |
|-------|-------------|
| `Brightness.dark` | Dark mode (default) |
| `Brightness.light` | Light mode |

## CSS Variables

Stylesheets define CSS custom properties that all components use. These are automatically injected into the document.

### Core Colors

```css
--background          /* Page background */
--foreground          /* Default text color */
--card                /* Card background */
--card-foreground     /* Text on cards */
--popover             /* Popover background */
--popover-foreground  /* Text in popovers */
--primary             /* Primary brand color */
--primary-foreground  /* Text on primary */
--secondary           /* Secondary color */
--secondary-foreground
--muted               /* Muted backgrounds */
--muted-foreground    /* Muted text */
--accent              /* Accent color */
--accent-foreground
--destructive         /* Error/danger color */
--destructive-foreground
--border              /* Border color */
--input               /* Input border color */
--ring                /* Focus ring color */
```

### Status Colors

```css
--success             /* Success state */
--success-foreground
--warning             /* Warning state */
--warning-foreground
--info                /* Info state */
--info-foreground
```

### Structure Tokens

```css
--radius              /* Base border radius (e.g., 0.5rem) */
--font-sans           /* Sans-serif font stack */
--font-mono           /* Monospace font stack */
```

### Arcane Aliases

Stylesheets also define `--arcane-*` prefixed variables for package-level components:

```css
--arcane-background
--arcane-foreground
--arcane-primary
--arcane-primary-foreground
--arcane-secondary
--arcane-accent
--arcane-muted
--arcane-border
--arcane-radius
--arcane-radius-sm
--arcane-radius-md
--arcane-radius-md
/* ... and more */
```

## Using CSS Variables in Styles

Reference these variables in your `ArcaneStyleData`:

```dart
ArcaneBox(
  style: const ArcaneStyleData(
    background: Background.card,
    border: BorderPreset.standard,
    textColor: TextColor.cardForeground,
    borderRadius: Radius.md,
  ),
  children: [...],
)
```

Or use the type-safe presets which map to these variables:

```dart
ArcaneBox(
  style: const ArcaneStyleData(
    background: Background.card,
    textColor: TextColor.cardForeground,
    border: BorderPreset.standard,
    borderRadius: Radius.md,
  ),
  children: [...],
)
```

## Component Renderers

Each stylesheet provides its own implementation of all components via the renderer system. Access renderers through context:

```dart
@override
Widget build(BuildContext context) {
  return Button(
    label: 'Click me',
    onPressed: () {},
  );
}
```

## Creating Custom Stylesheets

To create a custom stylesheet, extend `ArcaneStylesheet`:

```dart
class MyStylesheet extends ArcaneStylesheet {
  const MyStylesheet();

  @override
  String get id => 'my-style';

  @override
  String get name => 'My Style';

  @override
  ComponentRenderers get renderers => const MyRenderers();

  @override
  LayoutRenderers get layouts => const MyLayouts();

  @override
  String get baseCss => '''
    :root {
      --background: #ffffff;
      --foreground: #000000;
      --primary: #3b82f6;
      --primary-foreground: #ffffff;
      /* ... define all required variables */
    }

    .dark {
      --background: #0a0a0a;
      --foreground: #fafafa;
      /* ... dark mode overrides */
    }
  ''';

}
```

Your custom `MyRenderers` class must implement all methods in `ComponentRenderers`, and `MyLayouts` must implement adaptive layout slots such as `ArcaneScaffold`.

Fonts must be committed with the host site's assets and declared with local
`@font-face` URLs. `ArcaneStylesheet` intentionally has no remote stylesheet
hook, so activating a theme never adds a network font or CSS request.

## Theme Toggle

Use `ArcaneThemeToggle` to let users switch between light and dark modes:

```dart
ArcaneThemeToggle(
  isDark: true,
  onChanged: (isDark) {
    // Handle theme change
  },
)
```

## Static Site Support

When building static sites with `jaspr build`, include fallback scripts for interactivity:

```dart
ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  includeFallbackScripts: true,
  home: MyApp(),
)
```

This injects JavaScript that provides interactivity when Jaspr client hydration is unavailable.
