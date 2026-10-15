# Ascii

A paper-and-ink theme for Arcane Jaspr: monospace type, fine datum rules, bracketed controls, stepped readouts, and text that resolves into place. Every Arcane component uses the existing semantic renderer contracts, including forms, navigation, tables, charts, overlays, galleries, and layout primitives.

## Install

For a local checkout, add the package alongside Arcane:

```yaml
dependencies:
  arcane_jaspr:
    path: /path/to/arcane_jaspr
  arcane_jaspr_ascii:
    path: /path/to/arcane_jaspr/packages/arcane_jaspr_ascii

dependency_overrides:
  arcane_jaspr:
    path: /path/to/arcane_jaspr
  arcane_jaspr_shadcn:
    path: /path/to/arcane_jaspr/packages/arcane_jaspr_shadcn
```

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';

ArcaneApp(
  stylesheet: const AsciiStylesheet(),
  brightness: Brightness.light,
  home: Column(children: const <Widget>[
    AsciiDatum(label: 'Runtime', value: 'LIVE'),
    AsciiText('Every signal, in view.', cursor: true),
    Button(label: 'Inspect'),
  ]),
)
```

The stylesheet ID is `ascii`; its display name is `Ascii`. Use the usual Arcane brightness controls for the light paper and dark ink palettes. The font stack uses locally available Geist Mono, IBM Plex Mono, Hack, and system monospace fonts. The package makes no external font requests.

## Text and datum motion

`AsciiText` accepts `motion` (`AsciiTextMotion.decode`, `typewriter`, or `none`), `duration`, `delay`, `cursor`, and `classes`. Characters retain their final layout throughout the entrance, so surrounding content stays in place. Unicode graphemes remain intact. Assistive technology receives the complete text once, immediately. The cursor blinks four times and then disappears.

```dart
const AsciiText(
  'Connection established.',
  motion: AsciiTextMotion.typewriter,
  duration: Duration(milliseconds: 1200),
  cursor: true,
)

const AsciiDatum(label: 'Sample window', value: '60 seconds')
```

`AsciiDatum` draws a flexible horizontal datum between its `label` and optional `value`. Set `animated: false` for a stationary rule. Its plus marks and rule are decorative; the label and value remain ordinary readable text. Both components accept `classes` and a Jaspr `key`; change the key to replay an entrance.

## Component behavior

- Buttons open their brackets on hover and keyboard focus; inputs and selected items use complete outlines and fills.
- Menus and dialogs resolve into view. Sheets and drawers retain directional motion. Cards respond to interaction without moving their descendants.
- Progress fills advance in measured steps. Indeterminate loading uses terminal glyphs, and skeletons pulse only while displayed as loading states.
- Tables, counters, and specification rows use aligned numerals. Structural layouts retain normal document flow and inherit the theme through their children.

All CSS motion respects `prefers-reduced-motion`. Set `data-ascii-motion="off"` on a containing element to disable CSS motion for that subtree and reveal text immediately. Slot counters also honor the system preference and pause their timers while the document is hidden. Focus indicators remain visible in forced-colors mode.

## Custom surfaces

Use the standard Arcane tokens (`--background`, `--foreground`, `--card`, `--border`, `--input`, `--primary`, and `--muted-foreground`) for application surfaces. `--input` supplies stronger control boundaries; `--ascii-rule` and `--ascii-soft-rule` supply decorative rules. Motion uses `--ascii-duration` and `--ascii-ease`.

Optional classes are `ascii-surface` for a square framed surface, `ascii-label` for compact uppercase metadata, `ascii-readout` for numeric text, `ascii-divider` for a horizontal rule, and `ascii-enter` for a finite opacity entrance. Keep controls and content in normal document flow; no animation requires a transformed containing block.

The Arcane documentation app includes the `/ascii` workbench with replay controls and the complete interactive component catalog. Lexicon integrations can offer `AsciiStylesheet()` as an ordinary `KBStylesheetOption`.
