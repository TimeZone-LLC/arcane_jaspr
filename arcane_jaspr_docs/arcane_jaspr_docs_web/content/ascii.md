---
title: Ascii
description: The Ascii theme, with live component examples, text motion, and datum lines.
layout: kb
landing: true
component: ascii-showcase
pageNav: false
order: 0
---

## Installation

Ascii is a renderer package for Arcane Jaspr. Add the core and theme packages to a Jaspr project using local checkout paths:

```yaml
dependencies:
  arcane_jaspr:
    path: ../arcane_jaspr
  arcane_jaspr_ascii:
    path: ../arcane_jaspr/packages/arcane_jaspr_ascii

dependency_overrides:
  arcane_jaspr:
    path: ../arcane_jaspr
  arcane_jaspr_shadcn:
    path: ../arcane_jaspr/packages/arcane_jaspr_shadcn
```

Import the theme and pass `AsciiStylesheet` to the application root. Existing Arcane buttons, forms, tables, menus, dialogs, and layouts use the theme automatically.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';

ArcaneApp(
  stylesheet: const AsciiStylesheet(),
  brightness: Brightness.light,
  home: const Column(
    children: <Widget>[
      AsciiDatum(label: 'PROJECT', value: 'READY'),
      AsciiText('A precise place to begin.'),
      Text('Build with the existing Arcane component API.'),
    ],
  ),
)
```

## Paper and ink

`Brightness.light` uses the paper palette. `Brightness.dark` uses the ink palette. Keep the selected brightness in application state and rebuild `ArcaneApp` when a toggle changes it. Theme selection does not require separate component trees or custom control implementations.

```dart
ArcaneApp(
  stylesheet: const AsciiStylesheet(),
  brightness: darkMode ? Brightness.dark : Brightness.light,
  home: Button.secondary(
    label: darkMode ? 'Use paper' : 'Use ink',
    onPressed: () => setState(() => darkMode = !darkMode),
  ),
)
```

## Text motion

`AsciiText` supports a character decode, a typewriter reveal, or static text. Choose a short duration for interface labels and a longer one for a page introduction. Keep long reading passages as ordinary `Text`.

```dart
const AsciiText(
  'Connection established.',
  motion: AsciiTextMotion.decode,
  duration: Duration(milliseconds: 900),
)

const AsciiText(
  'Waiting for the next command.',
  motion: AsciiTextMotion.typewriter,
  duration: Duration(milliseconds: 1400),
  delay: Duration(milliseconds: 150),
  cursor: true,
)
```

| Property | Default | Purpose |
| --- | --- | --- |
| `motion` | `AsciiTextMotion.decode` | `decode`, `typewriter`, or `none` |
| `duration` | `900 ms` | Reveal duration |
| `delay` | `Duration.zero` | Time before the reveal begins |
| `cursor` | `false` | Show the terminal cursor |
| `classes` | `null` | Add a CSS class to the text specimen |

## Datum lines

`AsciiDatum` places a label and optional value on a ruled line. Use it for section markers, metadata, status summaries, and measurements. Its line draws into place when animated.

```dart
const AsciiDatum(label: 'RENDERER', value: 'ASCII')
const AsciiDatum(label: 'SECTION 03 / INPUTS')
const AsciiDatum(label: 'STATUS', value: 'READY', animated: false)
```

## Component motion

The stylesheet applies its motion language to the shared Arcane component families. Controls respond to hover, focus, selection, and press; disclosure and overlay surfaces enter when opened; progress and loading components retain their state-specific motion. The component lab above contains every live demo in the documentation registry, with the same state and event handling used by other themes.

Use [the component catalog](/docs/components-catalog) for the full public surface and the component pages for properties and examples. Pick Ascii in the header to view any component page with this theme.

## Reduced motion

Ascii respects `prefers-reduced-motion: reduce`: text appears immediately and decorative movement stops. Use `AsciiTextMotion.none` and `AsciiDatum(animated: false)` when a particular element should always remain still. The specimen pause control above demonstrates these static forms without changing your system preference.

To suppress CSS motion within a region, set `data-ascii-motion="off"` on its container. Timer-driven components such as `ArcaneSlotCounter` follow the system reduced-motion preference and page visibility; use their own controls to pause them. Keep important content in the document even when an animation has not run, and do not rely on motion to communicate success or failure.

## Arcane Lexicon

Pass the same stylesheet to a documentation site. Ascii includes the document typography, navigation, search, and datum styling; no separate knowledge-base renderer is required.

```dart
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:arcane_lexicon/arcane_lexicon.dart';

await KnowledgeBaseApp.create(
  config: const SiteConfig(
    name: 'Project documentation',
    contentDirectory: 'content',
    themeToggleEnabled: true,
    defaultTheme: KBThemeMode.light,
  ),
  stylesheet: const AsciiStylesheet(),
)
```
