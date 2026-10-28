# Arcane Jaspr Neubrutalism

Neubrutalism renderer package for Arcane Jaspr. Bold pastel surfaces, thick black borders, hard offset shadows, no blur, no gradients. Comic-book aesthetic with modern UI primitives.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';

ArcaneApp(
  stylesheet: const NeubrutalismStylesheet(theme: NeubrutalismTheme.yellow),
  home: MyApp(),
)
```

Available themes: `yellow`, `pink`, `mint`, `orange`, `sky`, `lavender`, `lime`, `red`, `redBlack`, `greyscale`.

Use `NeubrutalismStylesheet(variant: NeubrutalismVariant.neuComic)` for comic typography, paper surfaces, square controls, and proportionate gallery panels with integrated captions. Both appearances include embedded fonts; no remote font requests are needed. Font licenses are listed in `FONT_LICENSES.md`.

Corners are square by default. Set `rounded: true` to enable the stylesheet's rounded treatment.

Reference: https://www.neobrutalism.dev/

Use `package:arcane_jaspr` for core widgets and this package only for the concrete stylesheet.
