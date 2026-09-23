---
title: Quick Start
description: Build the canonical counter app with the Flutter-first Arcane Jaspr surface
layout: kb
previous:
  url: /docs/installation
  title: Installation
---

# Quick Start

This is the baseline Arcane Jaspr example. If you can write this app, you are on the intended primary surface.

## Counter App

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

const ArcaneStylesheet shadcnStylesheet = ShadcnStylesheet(
  theme: ShadcnTheme.midnight,
);
const ArcaneStylesheet neonStylesheet = NeonStylesheet(
  theme: NeonTheme.green,
);
const ArcaneStylesheet neubrutalismStylesheet = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.yellow,
);
const ArcaneStylesheet selectedStylesheet = shadcnStylesheet;

void main() {
  runApp(const App());
}

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

## What This Confirms

- You imported `package:arcane_jaspr/arcane_jaspr.dart` plus one concrete renderer package
- You used `StatefulWidget`, `State`, `Widget build`, and `runApp`
- You let `ArcaneScaffold` pass semantic layout slots to the active stylesheet
- You did not need HTML wrappers or raw Jaspr types

## Next Steps

- Browse [Component Catalog](/docs/components-catalog)
- Read [Styling Concepts](/docs/concepts/styling)
- Read [Theme Concepts](/docs/concepts/theming)
