# ArcaneNeon

Documentation workspace for `arcane_jaspr`.

## What Lives Here

- `arcane_neon_web/`: the static docs site
- `arcane_neon_web/content/docs/components-catalog.md`: generated current-state catalog
- `arcane_neon_web/lib/components/demo_registry.dart`: live demo snippets and preview registry

## Development

```bash
cd arcane_neon_web
dart pub get
dart run tool/generate_component_catalog.dart
dart ../../tool/arcane_jaspr_demo.dart
```

## Build

```bash
cd arcane_neon_web
dart run tool/build.dart --domain=https://timezone-llc.github.io/arcane_jaspr --base-url=/arcane_jaspr
```

The build script regenerates the component catalog before the search index and static build.
