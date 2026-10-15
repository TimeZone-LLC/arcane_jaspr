---
title: Installation
description: Add Arcane Jaspr to a Jaspr project or scaffold a project with Oracular
layout: kb
previous:
  url: /docs
  title: Introduction
next:
  url: /docs/quick-start
  title: Quick Start
---

# Installation

There are two supported starting points: scaffold a project with Oracular or add Arcane Jaspr to an existing Jaspr app.

## Option 1: Scaffold with Oracular

```bash
dart pub global activate oracular
oracular create app --template arcane_jaspr_app --name my_app
oracular create app --template arcane_jaspr_docs --name my_docs
```

The repo-owned templates already target the Flutter-first Arcane Jaspr surface.

## Option 2: Add Arcane Jaspr to an Existing Jaspr App

### Prerequisites

- Dart SDK `>=3.10.0`
- Jaspr CLI

```bash
dart pub global activate jaspr_cli
```

### Add the Package

```yaml
dependencies:
  arcane_jaspr: ^6.0.0
  arcane_jaspr_ascii: ^1.0.0
  arcane_jaspr_neon: ^6.0.0
  arcane_jaspr_neubrutalism: ^6.0.0
  arcane_jaspr_shadcn: ^6.0.0
```

```bash
dart pub get
```

### Use the Primary Import

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
```

Only add these if you intentionally need them:

```dart
import 'package:arcane_jaspr/html.dart';
import 'package:arcane_jaspr/web.dart';
```

### Wrap the App Root

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

const ArcaneStylesheet asciiStylesheet = AsciiStylesheet();
const ArcaneStylesheet shadcnStylesheet = ShadcnStylesheet(
  theme: ShadcnTheme.midnight,
);
const ArcaneStylesheet neonStylesheet = NeonStylesheet(
  theme: NeonTheme.green,
);
const ArcaneStylesheet neubrutalismStylesheet = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.yellow,
);
const ArcaneStylesheet selectedStylesheet = asciiStylesheet;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneApp(
      stylesheet: selectedStylesheet,
      brightness: Brightness.dark,
      home: const Text('Ready'),
    );
  }
}
```

## Run the App

```bash
jaspr serve
```

## Build Static Output

```bash
jaspr build
```
