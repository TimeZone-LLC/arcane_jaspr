# Arcane Jaspr Neon Web

Static documentation site for `arcane_jaspr`.

## Development

```bash
dart pub get
dart run tool/generate_component_catalog.dart
dart ../../tool/arcane_jaspr_demo.dart
```

The demo serves at `http://localhost:8080` and replaces the previous Arcane Jaspr demo process before launching.

## Build

```bash
dart run tool/build.dart --domain=https://timezone-llc.github.io/arcane_jaspr --base-url=/arcane_jaspr
```

## Primary Documentation Rules

- Teach `package:arcane_jaspr/arcane_jaspr.dart` first
- Keep HTML wrappers on `package:arcane_jaspr/html.dart`
- Keep raw Jaspr escape hatches on `package:arcane_jaspr/web.dart`
- Prefer Flutter-shaped examples with `Widget build(BuildContext context)` and no explicit type arguments in normal usage
