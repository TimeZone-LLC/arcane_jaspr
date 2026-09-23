# Flutter authoring

Import `package:arcane_jaspr/arcane_jaspr.dart` for widgets and layout types.
Use `package:arcane_jaspr/flutter.dart` when only the authoring base classes,
keys, builders, and callbacks are needed. Both entry points use the same types.

`Widget` is a Jaspr `Component`, so an Arcane widget can contain a Jaspr
component without conversion. `StatelessWidget`, `StatefulWidget`, and
`InheritedWidget` use Jaspr's element tree and lifecycle.

## State

Use `widget` to read the current configuration. Override `didUpdateWidget`
to respond to a parent supplying new properties. Jaspr updates `widget`
before this hook and builds afterward. Call the superclass lifecycle methods.

```dart
class Counter extends StatefulWidget {
  final int initialValue;

  const Counter({this.initialValue = 0, super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) => Row(
    spacing: 12,
    children: <Widget>[
      Text('$_value'),
      Button(
        label: 'Increment',
        onPressed: () => setState(() => _value += 1),
      ),
    ],
  );
}
```

The `didUpdateComponent` override in Arcane's `State` is the Jaspr runtime
entry point. Application states override `didUpdateWidget`. Components that
extend Jaspr's own `StatefulComponent` continue to use Jaspr's own `State`.

## Layout

`Row` and `Column` extend `Flex` and use `spacing` for the distance between
children. Their cross axis alignment defaults to `CrossAxisAlignment.center`.
Set `CrossAxisAlignment.stretch` when children should span the cross axis.
`Row`, `Column`, `Flex`, and `Stack` accept an empty child list by default.

`Wrap` accepts `direction`, `alignment`, `runAlignment`, `spacing`,
`runSpacing`, and `WrapCrossAlignment`. Spacing defaults to zero, as in Flutter.
The main axis follows `direction`; `runSpacing` separates runs on the other
axis. The optional `reverse` parameter reverses the main axis in CSS.
For vertical runs, give the parent a definite height, such as
`SizedBox(height: 200, child: Wrap(direction: Axis.vertical, ...))`.
Without a bounded height, a vertical wrap remains one column at its natural height.

`Flexible` defaults to `FlexFit.loose`: CSS keeps the natural size and permits
shrinking. `Expanded` uses `FlexFit.tight` to fill remaining space. CSS flex
shrinking distributes space differently from Flutter's constraint algorithm;
matching constructor types does not imply identical browser geometry.

`Positioned` accepts numeric `top`, `right`, `bottom`, `left`, `width`, and
`height` values in CSS pixels. Supply at most two horizontal constraints and
two vertical constraints. `Positioned.fill` accepts edge overrides.
Use `style: ArcaneStyleData(...)` for CSS units such as percentages or `calc()`.

`SizedBox.expand` and `SizedBox.shrink` accept a child. Infinite dimensions
map to `100%`; the opposite finite dimension is retained. `Container` uses
the same infinity mapping. Percentage height still requires a bounded parent
under the browser's layout rules.

## Text

`Text.style` accepts a `TextStyle` with numeric `fontSize`, `letterSpacing`,
`wordSpacing`, and line-height multiplier `height`. It also accepts Flutter
names for font weight, font style, font family, color, background color,
decoration, decoration color, and overflow. Font names are quoted for CSS.
Use `textAlign`, `softWrap`, `maxLines`, and `overflow` on the `Text` widget.
The string is available through `Text.data`.

Single-line truncation stays within the parent width. For multiple lines,
ellipsis uses CSS line clamping, while clipping and visible overflow use
the element's computed line height through the CSS `lh` unit. Visible
overflow retains the allocated line height and permits text to paint outside it.

```dart
const Text.heading(
  'Account settings',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ),
)
```

Semantic constructors such as `Text.heading` and `Text.body` keep their HTML
tags and Arcane typography defaults. `TextStyle` overrides those defaults.
`copyWith` preserves fields that are not supplied. `merge` uses the supplied
style's non-null fields, or returns it directly when its `inherit` is false.
Rendering `inherit: false` resets supported typography to browser defaults.

`cssStyle` accepts `ArcaneStyleData` for CSS-specific options and overrides
the resolved text styles. `RichText` and `TextSpan` retain their existing
Arcane constructors and continue to accept `ArcaneStyleData` through `style`.

## Updating existing code

| Previous API | Current API |
| --- | --- |
| Arcane `State.component` | `State.widget` |
| Arcane `State.didUpdateComponent` | `State.didUpdateWidget` |
| `Row(gap: n)` / `Column(gap: n)` | `spacing: n` |
| `Column()` implicitly stretched children | Supply `crossAxisAlignment: CrossAxisAlignment.stretch` to retain stretching |
| String `Positioned` offsets such as `top: '12px'` | Numeric offsets such as `top: 12`; use `style` for other CSS units |
| `Wrap(mainAxisAlignment: MainAxisAlignment.center)` | `alignment: WrapAlignment.center` |
| `Wrap(wrapAlignment: value)` | `runAlignment: value` |
| `Wrap(crossAxisAlignment: CrossAxisAlignment.center)` | `crossAxisAlignment: WrapCrossAlignment.center` |
| Horizontal `Wrap(gap: g, rowGap: r, columnGap: c)` | `spacing: c ?? g, runSpacing: r ?? g` |
| `Wrap()` implicitly used an 8-pixel gap | Supply `spacing: 8, runSpacing: 8` to retain that spacing |
| `Text(..., align: value)` | `textAlign: value`, including named Text constructors |
| `Text(..., style: ArcaneStyleData(...))` | `cssStyle: ArcaneStyleData(...)`, including named Text constructors |
| `text.text` on a `Text` widget | `text.data` |

These are direct API changes. Update callers to the current names and types.
Renderer `RowProps`, `ColumnProps`, and `FlowProps` keep their CSS-oriented gap
properties; `FlowProps` adds `direction` for horizontal and vertical runs.

## Bridge boundaries

The library renders accessible HTML through Jaspr. It does not implement
Flutter's render objects, painting, or layout engine. Theme tokens and CSS
styling remain Arcane APIs. `TextStyle` supports browser typography rather than
Flutter painting options. `RichText`, `TextSpan`, `BoxConstraints`, and
`Alignment` still have differences from Flutter's types.
Use the APIs in this package when authoring a site; importing a Flutter
painting or rendering type does not make it usable by a browser renderer.
