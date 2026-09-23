---
title: Introduction
description: Arcane Jaspr primary surface and documentation map
layout: kb
---

# Introduction

Arcane Jaspr gives Jaspr a Flutter-shaped app surface without forcing you back into raw HTML or raw Jaspr APIs.

## Primary Import

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';
```

This is the normal app path.
It includes the Flutter-shaped base types, Arcane widgets, renderers, stylesheets, and theming utilities.

## Advanced Imports

```dart
import 'package:arcane_jaspr/html.dart';
import 'package:arcane_jaspr/web.dart';
```

Use `html.dart` only when you intentionally want low-level HTML wrappers.
Use `web.dart` only when you intentionally want raw Jaspr or DOM access.

## Same UI in Plain Jaspr

Plain Jaspr is still a strong fit when you want direct DOM control, explicit tag selection, and styling that stays close to the rendered HTML.

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

dom.article(
  classes: 'rounded-xl border border-slate-200 bg-white p-6 shadow-sm',
  [
    dom.p(
      classes: 'text-sm font-medium uppercase tracking-[0.2em] text-slate-500',
      [text('Pro workspace')],
    ),
    dom.h2(
      classes: 'mt-3 text-2xl font-semibold text-slate-950',
      [text('Ship dashboards faster')],
    ),
    dom.p(
      classes: 'mt-3 text-sm leading-6 text-slate-600',
      [
        text(
          'Invite teammates, share reports, and manage releases with one workspace.',
        ),
      ],
    ),
    dom.div(
      classes: 'mt-5 flex gap-3',
      [
        dom.button(
          classes: 'rounded-md bg-slate-950 px-4 py-2 text-sm font-medium text-white',
          events: {'click': (_) {}},
          [text('Start trial')],
        ),
        dom.button(
          classes: 'rounded-md border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700',
          [text('Preview plans')],
        ),
      ],
    ),
  ],
)
```

## Build With Arcane Jaspr

Arcane Jaspr targets the same outcome from a widget-first surface that reads closer to Flutter than to HTML authoring.

```dart
import 'package:arcane_jaspr/arcane_jaspr.dart';

Card.outlined(
  fillWidth: true,
  child: Column(
    spacing: 16,
    children: [
      const Text.label('Pro workspace'),
      const Text.heading2('Ship dashboards faster'),
      const Text.body(
        'Invite teammates, share reports, and manage releases with one workspace.',
      ),
      ButtonGroup(
        children: [
          Button.primary(
            label: 'Start trial',
            onPressed: () {},
            icon: ArcaneIcon.arrowRight(size: IconSize.sm),
            iconPosition: ButtonIconPosition.trailing,
          ),
          Button.secondary(
            label: 'Preview plans',
            onPressed: () {},
          ),
        ],
      ),
    ],
  ),
)
```

## Why The Arcane Version Exists

- Plain Jaspr asks you to think in DOM tags, class strings, and browser events.
- Arcane Jaspr asks you to think in widgets, layout primitives, component variants, and theme-driven rendering.
- The Flutter goal is not just shorter code. The goal is a different authoring model, where the first draft of a screen reads like app UI composition instead of HTML assembly.

If your target is a Flutter-like counter page, dashboard, settings screen, or form flow, the Arcane path should feel closer to `Card`, `Column`, `Text`, and `Button` composition. If you want raw HTML control, that remains available through the advanced imports.

## Start Here

- [Installation](/docs/installation)
- [Quick Start](/docs/quick-start)
- [Component Catalog](/docs/components-catalog)
- [Styling Concepts](/docs/concepts/styling)
- [Theme Concepts](/docs/concepts/theming)

## Documentation Scope

The primary docs path only covers the Flutter-first surface.
Advanced HTML wrappers are cataloged separately and are not treated as the default authoring experience.
