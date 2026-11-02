# Arcane Jaspr Neubrutalism

Neubrutalism renderer package for Arcane Jaspr, following [neubrutalism.com](https://neubrutalism.com/): flat colors, square corners, 3px outlines, and hard offset shadows. Dark mode uses warm charcoal surfaces, cream text, and black structural edges and shadows.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';

ArcaneApp(
  stylesheet: const NeubrutalismStylesheet(theme: NeubrutalismTheme.yellow),
  home: MyApp(),
)
```

Available themes: `yellow`, `pink`, `mint`, `orange`, `sky`, `lavender`, `lime`, `red`, `redBlack`, `greyscale`.

Corners are square by default, including switches. Set
`NeubrutalismStylesheet(rounded: true)` for rounded controls, cards, and overlays
in either variant. The option can change live without replacing the document.
Custom surfaces can follow `--nb-radius-tight`, `--nb-radius-soft`, and
`--nb-radius-soft-lg`. Explicit avatar shapes and edge-to-edge layout joins
retain their geometry.

The default yellow palette matches the reference's off-white canvas and yellow,
coral, and blue accents. `redBlack` keeps neutral dark surfaces and red accents.
`greyscale` uses neutral gray surfaces in both appearances. Dark inputs and
unselected controls use `--nb-control-line` for a readable boundary; saturated
controls use the black `--nb-line`. Both honor the `--nb-line-in` runtime override.

Typography uses Inter for body text, Space Grotesk for headings and controls,
Space Mono for code and badges, and Syne 800 for display type. All four fonts
are embedded as WOFF2, including Latin Extended glyphs. No remote requests or
asset-copy step are needed. Font provenance and licenses are in
[FONT_LICENSES.md](FONT_LICENSES.md).

Use `var(--font-display)` or the `neubrutalism-display` class for display titles.
Regular headings use Space Grotesk 700. Shadow tokens are `--nb-shadow-sm` (3px),
`--nb-shadow-md` (5px), `--nb-shadow-lg` (8px), and `--nb-shadow-xl` (12px), with
zero blur in both appearances. Flat and ghost variants remain unshadowed.

Use `package:arcane_jaspr` for core widgets and this package only for the concrete stylesheet.

## NeuComic

Use `NeubrutalismVariant.neuComic` for paper surfaces, inked panels, comic lettering,
and print patterns. The accent palette remains selectable with `theme`; the
variant uses warm cream paper in light mode and charcoal paper in dark mode.

```dart
ArcaneApp(
  stylesheet: const NeubrutalismStylesheet(
    variant: NeubrutalismVariant.neuComic,
    theme: NeubrutalismTheme.yellow,
  ),
  brightness: Brightness.light,
  home: MyApp(),
)
```

Bangers provides display lettering; Comic Neue provides readable body and
control text. Both are embedded with their OFL licenses. Cream and charcoal
surfaces, solid controls, and hard shadows keep the interface readable without
background textures. Explicit card decorations are preserved. The default
`classic` variant keeps the original appearance.

Inside the `neucomic` root, use `neucomic-panel` for a framed panel and
`neucomic-caption` for an inked caption. The `neucomic-halftone` and
`neucomic-hatch` utilities are opt-in illustration treatments; the theme does
not apply patterns to controls, cards, or page backgrounds.
`--neucomic-halftone` is a single-ink, uniform tint, not a color-separation
filter. Set `--neucomic-dot-ink`, `--neucomic-dot-radius`, and
`--neucomic-print-size` to choose its ink and coverage. The default radius of
1.2px on a 4px grid covers about 28% of the paper before antialiasing.
For non-touching dots, radius = grid spacing × √(coverage / π).

The Print Club illustrations use separate opaque ink screens over paper.
Dot area varies with the local tone; cyan and magenta screens sit at 15° and
75°, and yellow at 0°. Ink layers multiply where they overlap. The example
uses stylized spot inks, not an ICC-profiled CMYK print simulation.
`--neucomic-hatch` provides crosshatching.
Patterns disappear in forced-colors and print output; reduced-motion settings
remove animation.

The [Print Club example](../../examples/neubrutalism_print_club/README.md) includes
a live Classic/NeuComic selector and direct light/dark preview links.

## Controls and motion

`ArcaneSelect` and `ArcaneNativeSelect` both use the theme's custom listbox in
Classic and NeuComic. Arrow keys, Home/End, typeahead, Enter, Escape, and Tab work
with the styled menu. A hidden backing field preserves form submission,
required validation, and reset behavior without opening a native dropdown.

Buttons, selection marks, menus, disclosures, dialogs, sheets, drawers, toasts,
and interactive cards share short transitions. Progress and opt-in skeletons
animate; counters pause when hidden. Reduced-motion preferences disable motion
and let counters settle immediately. Explicit card decorations and accent colors
remain available.

Print Club's [component gallery](../../examples/neubrutalism_print_club/README.md)
contains 37 interactive fixtures covering all 104 renderer slots, with direct
Classic/NeuComic and light/dark controls.
