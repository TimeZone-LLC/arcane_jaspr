# Unreleased API changes

Update consumers together with this checkout. The package versions remain unchanged
until a release version is assigned. The public entry point remains
`package:arcane_jaspr/arcane_jaspr.dart`; renderer imports remain separate.

| Previous call | Current call |
| --- | --- |
| `component.title` in an Arcane `State<T>` | `widget.title` |
| `didUpdateComponent(oldComponent)` | `didUpdateWidget(oldWidget)`, including the `super` call |
| `Row(gap: 12)` / `Column(gap: 12)` | `Row(spacing: 12)` / `Column(spacing: 12)` |
| `Column(children: ...)` relying on stretched children | Add `crossAxisAlignment: CrossAxisAlignment.stretch` |
| `Positioned(top: '12px')` | `Positioned(top: 12)` |
| `Wrap(gap: 8)` | `Wrap(spacing: 8, runSpacing: 8)` |
| `Wrap(mainAxisAlignment: ..., wrapAlignment: ...)` | `Wrap(alignment: ..., runAlignment: ...)`, using `WrapAlignment` |
| `Wrap(rowGap: 4, columnGap: 8)` | `Wrap(runSpacing: 4, spacing: 8)` for the default horizontal axis |
| `Text('Title', align: ...)` | `Text('Title', textAlign: ...)` |
| `Text('Title', style: ArcaneStyleData(...))` | `Text('Title', cssStyle: ArcaneStyleData(...))` |
| `textWidget.text` | `textWidget.data` |
| `TextInput(onChange: ...)` or `onInput` | `TextInput(onChanged: ...)` |
| `TextInput(onSubmit: ...)` | `TextInput(onSubmitted: ...)` |
| `TextArea(onChange: ...)` or `onInput` | `TextArea(onChanged: ...)` |
| `ArcaneSelect(onChange: ...)`, `onInput`, or `onSelect` | `ArcaneSelect(onChanged: ...)` |
| `ArcaneNativeSelect(onChange: ...)` | `ArcaneNativeSelect(onChanged: ...)` |
| `ArcaneOtpInput(onChange: ...)` | `ArcaneOtpInput(onChanged: ...)` |
| Checkbox or switch `onToggle` | `onChanged` |
| `Button(attributes: {'type': 'submit'})` | `Button(type: ButtonType.submit)` |

`Wrap` now defaults to zero spacing. Set both spacing values to `8` if a layout
depended on the former default. Its cross-axis values use `WrapCrossAlignment`.
Vertical wrapping requires a definite parent height, for example
`SizedBox(height: 200, child: Wrap(direction: Axis.vertical, ...))`.
Without one, the children stay in one column at their natural height.
`Positioned` accepts numeric pixel constraints; use `style: ArcaneStyleData(...)`
for percentage or calculated web positioning.

`Text(softWrap: false)` keeps one line within its parent's width. Default and
clip overflow hide the excess text; ellipsis shows an ellipsis, and explicit
`TextOverflow.visible` permits painting outside that width.

The lifecycle adapter belongs to Arcane `StatefulWidget` classes. Renderer classes
that extend Jaspr's `StatefulComponent` still use Jaspr's `State` and lifecycle.
Runtime interaction fields such as `onChangeAction` keep their existing names.
The renderer props for text input now use `onSubmitted` as well.
Buttons use the typed `type` parameter when rendering their HTML type. Set
`ButtonType.submit` for form submission instead of passing a raw attribute.

Theme CSS changes include ShadCN state colors and focus borders, Neon control
geometry and native radio variants, and Windows95 native radio variants, readable
disabled text, and field state contrast. Custom CSS that targets the former radio
markup needs review. Explicit literal style overrides still take precedence.
ShadCN, Neon, and Windows95 radio option attributes (`data-arcane-group`,
`data-arcane-value`, and `data-arcane-state`) now belong to the native input.
Replace label selectors such as
`label[data-arcane-state="selected"]` with `label:has(input:checked)`.

## Local consumers

`anim-al/Anim.al/animal` has direct source updates for the lifecycle and input
callbacks. Existing columns explicitly retain their prior stretched alignment.
It also replaces older button-child, badge-icon, pricing-badge, and skeleton-radius
calls removed in Arcane Jaspr 4.0. The existing local dependency link remains in use.
Its icon-subset build check now reads the `ArcaneGlyph` factory return type.
Search and onboarding buttons use `ButtonType.submit`; onboarding sends both
click and Enter activation through its form handler.

`arcane_lexicon` reads `Text.data` when extracting Markdown text. This update is
required by the documentation app's local dependency graph.
Long documentation headings also wrap without hiding their anchor links.
Its page state and navigation layouts use `widget` and numeric `spacing`, with
explicit alignment where columns must stretch. Content loading excludes
non-Markdown files before decoding them.

Both QualityNode projects already use compatible APIs through local `.deps`
links. Rebuilding `QualityNode-web/qualitynode_web` and
`Qualitynode-Knowledgebase` applies the refreshed renderers and Lexicon.
Their release workflows still pin older core and Lexicon commits. After these
library changes are committed and available remotely, update the web's
`ARCANE_JASPR_REF` and the knowledgebase's core/Lexicon checkout pair together.
Keep the knowledgebase dependency-swap helper aligned with the same revisions.

`MyRHE/Unify-Relay/rhe_sign_web` uses `widget`, `didUpdateWidget`, and select
`onChanged` callbacks. Its native Jaspr states retain their original lifecycle.
Button and menu calls use labels and typed glyphs; workspace menu descriptions
identify parent workspaces. Core and ShadCN resolve from one local checkout
through ignored overrides that Docker excludes. `LOCAL_DEV.md` records setup.
Remote builds require the matching library changes on the declared Git branch
before this consumer migration can compile there.

See [Flutter authoring](flutter_authoring.md) for the remaining differences from
Flutter. These changes improve shared source conventions; they do not provide a
Flutter rendering engine, gesture arena, navigation stack, or stateful global keys.
