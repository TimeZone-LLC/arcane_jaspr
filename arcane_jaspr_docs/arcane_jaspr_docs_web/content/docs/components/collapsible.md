---
title: ArcaneDisclosure
description: Use collapsible disclosure when secondary content should stay accessible without dominating the page.
layout: kb
component: collapsible
---

# ArcaneDisclosure

Use collapsible disclosure when secondary content should stay accessible without dominating the page.

The live preview and code sample above use the neutral `package:arcane_jaspr/arcane_jaspr.dart` API. The selected stylesheet owns spacing, density, radius, color, and interaction styling, so the same app code can render differently under Shadcn or Neon.

## Controlled open state

By default the browser opens and closes the disclosure, and `open` only sets where it starts. Pass `onOpenChange` to own the state: a click on the summary calls it with the requested value, and the disclosure changes only when `open` does. Opens made outside it, such as find in page, are reported the same way. Clicks on links, buttons or fields inside the summary leave it alone.

```dart
ArcaneDisclosure.minimal(
  open: rulesOpen,
  onOpenChange: (bool open) => setState(() => rulesOpen = open),
  summary: Text('Spawn rules'),
  child: rulesForm,
)
```

Source: `lib/component/interactive/disclosure.dart`

See the [Component Catalog](/docs/components-catalog) for the full exported surface and source mapping.
