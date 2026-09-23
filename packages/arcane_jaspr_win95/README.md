# Arcane Jaspr Windows 95

A pixel-faithful Windows 95 theme for Arcane Jaspr: silver 3D bevels (raised
faces, sunken wells), navy title bars, segmented progress meters, chunky
beveled scrollbars, dotted focus rectangles, and the self-hosted MS Sans Serif
bitmap font. Everything is sharp-cornered and un-blurred.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';

ArcaneApp(
  stylesheet: const Win95Stylesheet(
    theme: Win95Theme.standard,
    chrome: Win95Chrome.classic,
  ),
  home: MyApp(),
)
```

- Light mode uses the real Win95 appearance schemes: `Win95Theme.standard`
  (teal desktop / navy title), `rainyDay`, `eggplant`, `desert`, `rose`.
- Dark mode uses dark silver faces and preserves the selected scheme. System
  high contrast uses real control borders when Windows removes bevel shadows.
- `Win95Chrome` controls how far the navy title-bar chrome reaches:
  `classic` (dialogs are windows, cards are panels, and this is the default),
  or `minimal` (no title bars).

Use `package:arcane_jaspr` for core widgets and this package only for the
concrete stylesheet. Swapping themes is a one-line change at the `ArcaneApp`
call site.

## Controls

Radio groups use native radio inputs in every variant. Standard options keep
round sunken wells; cards and buttons use full raised faces with pressed
selection. Option descriptions and icons are retained, horizontal options
wrap, and grid layouts respect `gridColumns` and `gap`.

Select menus respect `maxDropdownHeight`, scroll long lists, and use the navy
selection bar for keyboard focus. Semantic status colors remain readable on
both silver surface palettes. The `--w95-*-in` caption, desktop, and selection
hooks remain available for application accents.

## Fonts

The MIT-licensed "Pixelated MS Sans Serif" faces are committed as base64
`@font-face` blocks in `lib/src/win95_font.dart`. The theme therefore makes no
font request. If the embedded faces are unavailable, it falls back to the
system `MS Sans Serif` / `Tahoma` stack.
