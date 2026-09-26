# Arcane Jaspr

Arcane Jaspr gives Jaspr apps a Flutter-first UI surface.
Use familiar Dart widget structure, keep semantic HTML output, and only drop to HTML or raw Jaspr when you explicitly choose to.

See [Flutter authoring](doc/flutter_authoring.md) for supported conventions and
[upgrade notes](doc/upgrade_notes.md) for the current breaking changes.

## Install

```yaml
dependencies:
  arcane_jaspr: ^4.0.0
  arcane_jaspr_shadcn: ^4.0.0
  arcane_jaspr_neon: ^4.0.0
  arcane_jaspr_neubrutalism: ^4.0.0
  arcane_jaspr_win95: ^4.0.0
```

`arcane_jaspr` is the core package. Add one or more renderer packages
(`arcane_jaspr_shadcn`, `arcane_jaspr_neon`, `arcane_jaspr_neubrutalism`, `arcane_jaspr_win95`) for the
themes you want; pick a stylesheet from one of them at runtime.

## Demo

From the `arcane_jaspr` package root, serve the demo/docs app with:

```bash
dart run arcane_jaspr:serve
```

It serves at `http://localhost:8080` and replaces any previous Arcane Jaspr demo process using that port.

Build the same demo with:

```bash
dart run arcane_jaspr:serve build
```

## Import Surfaces

Use the primary import for normal app code:

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

const ArcaneStylesheet shadcnStylesheet = ShadcnStylesheet(
  theme: ShadcnTheme.midnight,
);
const ArcaneStylesheet neonStylesheet = NeonStylesheet(
  theme: NeonTheme.green,
);
const ArcaneStylesheet selectedStylesheet = shadcnStylesheet;
```

Only reach for the advanced layers when you need them:

```dart
import 'package:arcane_jaspr/html.dart';
import 'package:arcane_jaspr/web.dart';
```

## Counter Example

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _count = 0;

  void _increment() {
    setState(() => _count += 1);
  }

  @override
  Widget build(BuildContext context) {
    return ArcaneApp(
      stylesheet: selectedStylesheet,
      brightness: Brightness.dark,
      home: ArcaneScaffold(
        title: 'Counter',
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text.heading2('Count: $_count'),
              Button.primary(
                label: 'Increment',
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Common Examples

```dart
TextInput(
  label: 'Email',
  placeholder: 'you@example.com',
  type: TextInputType.email,
)

ArcaneCombobox(
  value: 'jaspr',
  options: const [
    ComboboxOption(value: 'jaspr', label: 'Jaspr'),
    ComboboxOption(value: 'flutter', label: 'Flutter'),
  ],
  onChanged: (String? value) {},
)

ArcaneMenubar(
  menus: const [
    ArcaneMenubarMenu(
      label: 'File',
      items: [MenuItemAction(label: 'New')],
    ),
  ],
)
```

## What The Primary Surface Includes

- `Widget`, `StatelessWidget`, `StatefulWidget`, `State`, `BuildContext`, and `runApp`
- `ArcaneApp`, neutral renderer contracts, adaptive layout contracts, and theme provider access
- Arcane widgets for layout, input, menus, dialogs, data display, adaptive scaffolds, and theming
- Type-safe styling through `ArcaneStyleData`

## Advanced Imports

`package:arcane_jaspr/html.dart` contains the low-level HTML wrapper layer such as `ArcaneDiv`, `ArcaneLabel`, `ArcaneLink`, tables, lists, and SVG helpers.
`package:arcane_jaspr/web.dart` exposes raw Jaspr and DOM escape hatches.

## Interactivity and SSR

Arcane Jaspr has two distinct interactivity mechanisms. Choosing the right one
matters for static / server-rendered output:

- Declarative `ArcaneInteraction` actions (passed via `action:`) are encoded into
  `data-arcane-*` attributes (for example `data-arcane-action`) and executed by the
  embedded JavaScript runtime that ships with the app. These work in fully static
  and server-rendered HTML, with no Jaspr client hydration required. This is the
  SSR-safe path. Use the `ArcaneInteraction` factories such as
  `ArcaneInteraction.openDialog(...)`, `.navigate(...)`, `.copy(...)`,
  `.toggleThemeMode`, and `.submitForm(...)`.
- Dart callbacks like `onPressed` / `onChanged` are wired as Jaspr event handlers
  and only fire when the app runs with Jaspr client hydration. In a purely static
  build, `onPressed` does nothing because there is no Dart event listener attached.

In short: if you need behavior in static output, use `action:`; reserve
`onPressed` / `onChanged` for hydrated client apps.

### Content-Security-Policy caveat

The interactivity runtime is injected as a single inline `<script>` element
(`ArcaneScriptsComponent` in `lib/util/interactivity/arcane_scripts.dart`, rendered
from `lib/component/support/app.dart` when `includeFallbackScripts` is true, which is
the default). Because the runtime is emitted inline rather than as an external file,
a strict Content-Security-Policy must allow inline scripts (for example
`script-src 'self' 'unsafe-inline'`). There is currently no built-in nonce hook on
the injected script, so CSP nonces are not yet supported out of the box. If you need
strict CSP, set `includeFallbackScripts: false` on `ArcaneApp` and provide the
runtime yourself through a CSP-compatible mechanism.

## Docs

- Package docs: [timezone-llc.github.io/arcane_jaspr](https://timezone-llc.github.io/arcane_jaspr/)
- Docs/demo app: `arcane_jaspr_docs/arcane_jaspr_docs_web`
- Generated component catalog: `arcane_jaspr_docs/arcane_jaspr_docs_web/content/docs/components-catalog.md`

## License

GNU Public
