---
title: Field
description: Lay out a label, a control, help text and errors as one accessible form field.
layout: kb
component: field
---

# Field

The field components follow shadcn's `Field` family. A field pairs a label with its control, puts help text and errors under it, and wires the accessibility links for you.

Source: `lib/component/form/form_field.dart`

```dart
ArcaneFieldGroup(
  children: [
    ArcaneFormField(
      controlId: 'npc-name',
      orientation: FieldOrientation.responsive,
      invalid: nameTaken,
      children: [
        ArcaneFieldLabel('Name', required: true),
        ArcaneFieldContent(
          children: [
            TextInput(value: name, onChanged: setName),
            ArcaneFieldDescription('Shown above the head.'),
            if (nameTaken) ArcaneFieldError('That name is taken.'),
          ],
        ),
      ],
    ),
  ],
)
```

## Labels and links

`ArcaneFieldLabel` renders a `<label for>` pointing at the field's `controlId`. Leave `controlId` out and the field generates one.

`TextInput`, `TextArea` and `ArcaneSelect` inside a field take that id on their own. They also link every `ArcaneFieldDescription` and `ArcaneFieldError` through `aria-describedby`, and set `aria-invalid` when the field is `invalid`. Put descriptions and errors directly in the field or in its `ArcaneFieldContent`, so the field can find them.

Any other control reads the same values from `ArcaneFieldScope.maybeOf(context)`: `controlId`, `describedBy`, `invalid` and `disabled`.

Add an info button or a reset link to the label line with `trailing`. Those widgets sit outside the `<label>`, so they stay out of the control's accessible name:

```dart
ArcaneFieldLabel(
  'Speed',
  trailing: [InfoButton(tip: 'Blocks per second.')],
)
```

Use `ArcaneFieldTitle` for a heading that labels no single control, such as a group of choices.

## Orientation

`FieldOrientation.vertical` (the default) puts the label above the control. `horizontal` puts it beside the control, which suits switches and checkboxes. `responsive` puts it beside the control once the enclosing `ArcaneFieldGroup` is at least 28rem wide and above it when the group is narrower. It is a container query on the group, so a form inside a narrow sheet stacks even on a wide screen.

Beside the control, the label takes the room it needs. Pass `labelWidth` for a fixed label column, so the controls of a long form line up:

```dart
ArcaneFormField(
  orientation: FieldOrientation.responsive,
  labelWidth: '11.25rem',
  children: [
    ArcaneFieldLabel('Skin'),
    ArcaneFieldContent(children: [
      TextInput(),
      ArcaneFieldDescription('A player name or a texture URL.'),
    ]),
  ],
)
```

With `labelWidth`, the label is as tall as one control, so its text stays level with the control's first line.

## States

`invalid: true` turns the label red and marks library controls `aria-invalid`. `ArcaneFieldError` shows one message as text and several as a list, each only once:

```dart
ArcaneFieldError.list(problems)
```

An error with no message renders nothing.

`disabled: true` dims the label and disables the library text controls and selects inside.

## Sets and separators

`ArcaneFieldSet` is a `<fieldset>` for related fields under an `ArcaneFieldLegend`. Its `disabled` flag disables every control inside, natively. `ArcaneFieldSeparator` draws a rule between fields, with optional text such as "or" on it.

```dart
ArcaneFieldSet(
  children: [
    ArcaneFieldLegend('Delivery'),
    ArcaneFieldDescription('Where the parcel goes.'),
    ArcaneFieldGroup(children: [
      ArcaneFormField(children: [ArcaneFieldLabel('Street'), TextInput()]),
      ArcaneFieldSeparator(text: 'or'),
      ArcaneFormField(children: [ArcaneFieldTitle('Pick-up point')]),
    ]),
  ],
)
```

## Hand-built controls

An `<input>` with the `arcane-text-input` class or a `<textarea>` with `arcane-textarea` looks like `TextInput` and `TextArea` at rest under every stylesheet, with no app CSS: height, padding, border, radius, placeholder colour, focus ring, invalid ring (`aria-invalid="true"`) and disabled state.

## Styling hooks

Every part carries an `arcane-field-*` class and the shadcn `data-slot` attribute (`field`, `field-label`, `field-content`, `field-description`, `field-error`, `field-group`, `field-set`, `field-legend`, `field-separator`). The field root also carries `data-orientation`, `data-invalid` and `data-disabled`.

## ArcaneFieldWrapper

`ArcaneFieldWrapper` puts a label, description and error around one control in a single call. Set `fieldId` to the `id` of the wrapped input to associate the visible label with that control.

Source: `lib/component/form/field_wrapper.dart`

See the [Component Catalog](/docs/components-catalog) for the full exported surface and source mapping.
