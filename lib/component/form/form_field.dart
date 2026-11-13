import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr/dom.dart' as dom;

import '../../core/rendering/field_identity.dart';
import '../../util/classes.dart';
import '../../util/style_types/arcane_style_data.dart';

/// How an [ArcaneFormField] places its label against its control.
enum FieldOrientation {
  /// Label above the control.
  vertical,

  /// Label beside the control.
  horizontal,

  /// Label beside the control once the enclosing [ArcaneFieldGroup] is at
  /// least 28rem wide, above it when narrower.
  responsive,
}

/// Size of an [ArcaneFieldLegend].
enum FieldLegendVariant { legend, label }

/// The ids and state an [ArcaneFormField] shares with its children.
///
/// Library text inputs, text areas and native selects read it to take the
/// field's id, description and error links, invalid flag and disabled flag.
/// Other controls can read it with [ArcaneFieldScope.maybeOf].
class ArcaneFieldScope extends InheritedWidget {
  final String controlId;
  final bool invalid;
  final bool disabled;

  /// Ids of the field's descriptions and errors, in document order.
  final List<String> describedByIds;
  final Map<Widget, String> _messageIds;

  const ArcaneFieldScope._({
    required this.controlId,
    required this.invalid,
    required this.disabled,
    required this.describedByIds,
    required Map<Widget, String> messageIds,
    required super.child,
  }) : _messageIds = messageIds;

  static ArcaneFieldScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedComponentOfExactType<ArcaneFieldScope>();

  /// The value for a control's `aria-describedby`, or null when the field has
  /// no description or error.
  String? get describedBy =>
      describedByIds.isEmpty ? null : describedByIds.join(' ');

  String? idOf(Widget message) => _messageIds[message];

  /// Merges the field's links into a control's own [attributes].
  Map<String, String>? controlAttributes(Map<String, String>? attributes) {
    final String? own = attributes?['aria-describedby'];
    final String links = <String>[...describedByIds, ?own].join(' ');
    if (links.isEmpty && !invalid) {
      return attributes;
    }
    return <String, String>{
      ...?attributes,
      if (links.isNotEmpty) 'aria-describedby': links,
      if (invalid) 'aria-invalid': 'true',
    };
  }

  @override
  bool updateShouldNotify(covariant ArcaneFieldScope oldComponent) {
    if (controlId != oldComponent.controlId ||
        invalid != oldComponent.invalid ||
        disabled != oldComponent.disabled ||
        _messageIds.length != oldComponent._messageIds.length) {
      return true;
    }
    for (final MapEntry<Widget, String> entry in _messageIds.entries) {
      if (oldComponent._messageIds[entry.key] != entry.value) return true;
    }
    return false;
  }
}

/// One form field: a label, a control and its help, in the shadcn `Field`
/// layout.
///
/// The label points at [controlId] (generated when null). Library text
/// inputs, text areas and native selects inside take that id and link the
/// field's [ArcaneFieldDescription]s and [ArcaneFieldError]s through
/// `aria-describedby`; put those directly in the field or in its
/// [ArcaneFieldContent] so the field can find them.
class ArcaneFormField extends StatelessWidget {
  final List<Widget> children;
  final FieldOrientation orientation;
  final String? controlId;
  final bool invalid;
  final bool disabled;

  /// A fixed label column (a CSS length) when the label sits beside the
  /// control. The control takes the rest of the row.
  final String? labelWidth;
  final List<String>? classes;
  final ArcaneStyleData? styles;
  final Map<String, String> attributes;

  const ArcaneFormField({
    required this.children,
    this.orientation = FieldOrientation.vertical,
    this.controlId,
    this.invalid = false,
    this.disabled = false,
    this.labelWidth,
    this.classes,
    this.styles,
    this.attributes = const <String, String>{},
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      FieldIdentity(id: controlId, builder: _build);

  Widget _build(String id) {
    final Map<Widget, String> messageIds = Map<Widget, String>.identity();
    final List<String> describedBy = <String>[];
    int descriptions = 0;
    int errors = 0;
    void collect(List<Widget> widgets) {
      for (final Widget widget in widgets) {
        if (widget is ArcaneFieldContent) {
          collect(widget.children);
        } else if (widget is ArcaneFieldDescription) {
          descriptions++;
          final String messageId =
              widget.id ??
              (descriptions == 1
                  ? '$id-description'
                  : '$id-description-$descriptions');
          messageIds[widget] = messageId;
          describedBy.add(messageId);
        } else if (widget is ArcaneFieldError && widget.hasContent) {
          errors++;
          final String messageId =
              widget.id ?? (errors == 1 ? '$id-error' : '$id-error-$errors');
          messageIds[widget] = messageId;
          describedBy.add(messageId);
        }
      }
    }

    collect(children);
    return ArcaneFieldScope._(
      controlId: id,
      invalid: invalid,
      disabled: disabled,
      describedByIds: describedBy,
      messageIds: messageIds,
      child: dom.div(
        classes: cx(<String?>['arcane-field', ...?classes]),
        attributes: <String, String>{
          ...attributes,
          'role': 'group',
          'data-slot': 'field',
          'data-orientation': orientation.name,
          if (invalid) 'data-invalid': 'true',
          if (disabled) 'data-disabled': 'true',
          if (labelWidth != null) 'data-label-width': 'true',
        },
        styles: _styles(<String, String>{
          '--arcane-field-label-width': ?labelWidth,
        }, styles),
        children,
      ),
    );
  }
}

/// Stacks a field's control and its help, or a label and its description
/// beside a checkbox or switch.
class ArcaneFieldContent extends StatelessWidget {
  final List<Widget> children;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldContent({
    required this.children,
    this.classes,
    this.styles,
    super.key,
  });

  @override
  Widget build(BuildContext context) => dom.div(
    classes: cx(<String?>['arcane-field-content', ...?classes]),
    attributes: const <String, String>{'data-slot': 'field-content'},
    styles: _styles(const <String, String>{}, styles),
    children,
  );
}

/// The label of an [ArcaneFormField], pointing at the field's control.
///
/// [trailing] widgets (an info button, a reset link) sit on the label line
/// but outside the `<label>`, so they stay out of the control's name.
class ArcaneFieldLabel extends StatelessWidget {
  final String? text;
  final Widget? child;

  /// The labelled control's id. Defaults to the enclosing field's control id.
  final String? forId;
  final bool required;
  final List<Widget> trailing;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldLabel(
    String this.text, {
    this.forId,
    this.required = false,
    this.trailing = const <Widget>[],
    this.classes,
    this.styles,
    super.key,
  }) : child = null;

  /// A label with any content, such as a checkbox and its text for a choice
  /// card.
  const ArcaneFieldLabel.child(
    Widget this.child, {
    this.forId,
    this.required = false,
    this.trailing = const <Widget>[],
    this.classes,
    this.styles,
    super.key,
  }) : text = null;

  @override
  Widget build(BuildContext context) {
    final String? target =
        forId ?? ArcaneFieldScope.maybeOf(context)?.controlId;
    final List<Widget> content = <Widget>[
      child ?? Component.text(text!),
      if (required)
        const dom.span(
          classes: 'arcane-field-required',
          attributes: <String, String>{'aria-hidden': 'true'},
          <Widget>[Component.text('*')],
        ),
    ];
    final String classNames = cx(<String?>['arcane-field-label', ...?classes]);
    if (trailing.isEmpty) {
      return dom.label(
        htmlFor: target,
        classes: classNames,
        attributes: const <String, String>{'data-slot': 'field-label'},
        styles: _styles(const <String, String>{}, styles),
        content,
      );
    }
    return dom.div(
      classes: classNames,
      attributes: const <String, String>{'data-slot': 'field-label'},
      styles: _styles(const <String, String>{}, styles),
      <Widget>[
        dom.label(htmlFor: target, classes: 'arcane-field-label-text', content),
        ...trailing,
      ],
    );
  }
}

/// A heading styled like [ArcaneFieldLabel] for a field that labels no
/// single control, such as a choice card or a read-only value.
class ArcaneFieldTitle extends StatelessWidget {
  final String? text;
  final Widget? child;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldTitle(
    String this.text, {
    this.classes,
    this.styles,
    super.key,
  }) : child = null;

  const ArcaneFieldTitle.child(
    Widget this.child, {
    this.classes,
    this.styles,
    super.key,
  }) : text = null;

  @override
  Widget build(BuildContext context) => dom.div(
    classes: cx(<String?>['arcane-field-title', ...?classes]),
    attributes: const <String, String>{'data-slot': 'field-label'},
    styles: _styles(const <String, String>{}, styles),
    <Widget>[child ?? Component.text(text!)],
  );
}

/// Help text for a field or a fieldset, linked to the field's control.
class ArcaneFieldDescription extends StatelessWidget {
  final String? text;
  final Widget? child;

  /// Overrides the generated id (`<control id>-description`).
  final String? id;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldDescription(
    String this.text, {
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : child = null;

  const ArcaneFieldDescription.child(
    Widget this.child, {
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : text = null;

  @override
  Widget build(BuildContext context) => dom.p(
    id: ArcaneFieldScope.maybeOf(context)?.idOf(this) ?? id,
    classes: cx(<String?>['arcane-field-description', ...?classes]),
    attributes: const <String, String>{'data-slot': 'field-description'},
    styles: _styles(const <String, String>{}, styles),
    <Widget>[child ?? Component.text(text!)],
  );
}

/// The field's validation message, announced as an alert.
///
/// Renders nothing when it has no message. Several [errors] are listed once
/// each; a single one shows as plain text.
class ArcaneFieldError extends StatelessWidget {
  final String? message;
  final List<String> errors;
  final Widget? child;

  /// Overrides the generated id (`<control id>-error`).
  final String? id;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldError(
    this.message, {
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : errors = const <String>[],
       child = null;

  const ArcaneFieldError.list(
    this.errors, {
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : message = null,
       child = null;

  const ArcaneFieldError.child(
    Widget this.child, {
    this.id,
    this.classes,
    this.styles,
    super.key,
  }) : message = null,
       errors = const <String>[];

  List<String> get _messages => <String>{
    if (message != null && message!.trim().isNotEmpty) message!,
    for (final String error in errors)
      if (error.trim().isNotEmpty) error,
  }.toList();

  bool get hasContent => child != null || _messages.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final List<String> messages = _messages;
    if (child == null && messages.isEmpty) {
      return const Component.fragment(<Widget>[]);
    }
    return dom.div(
      id: ArcaneFieldScope.maybeOf(context)?.idOf(this) ?? id,
      classes: cx(<String?>['arcane-field-error', ...?classes]),
      attributes: const <String, String>{
        'role': 'alert',
        'data-slot': 'field-error',
      },
      styles: _styles(const <String, String>{}, styles),
      <Widget>[
        if (child != null)
          child!
        else if (messages.length == 1)
          Component.text(messages.single)
        else
          dom.ul(<Widget>[
            for (final String text in messages)
              dom.li(<Widget>[Component.text(text)]),
          ]),
      ],
    );
  }
}

/// A stack of fields. Responsive fields inside switch layout on this group's
/// width.
class ArcaneFieldGroup extends StatelessWidget {
  final List<Widget> children;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldGroup({
    required this.children,
    this.classes,
    this.styles,
    super.key,
  });

  @override
  Widget build(BuildContext context) => dom.div(
    classes: cx(<String?>['arcane-field-group', ...?classes]),
    attributes: const <String, String>{'data-slot': 'field-group'},
    styles: _styles(const <String, String>{}, styles),
    children,
  );
}

/// A `<fieldset>` of related fields under an [ArcaneFieldLegend].
class ArcaneFieldSet extends StatelessWidget {
  final List<Widget> children;

  /// Disables every control inside, natively.
  final bool disabled;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldSet({
    required this.children,
    this.disabled = false,
    this.classes,
    this.styles,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Component.element(
    tag: 'fieldset',
    classes: cx(<String?>['arcane-field-set', ...?classes]),
    attributes: <String, String>{
      'data-slot': 'field-set',
      if (disabled) 'disabled': 'true',
      if (disabled) 'data-disabled': 'true',
    },
    styles: _styles(const <String, String>{}, styles),
    children: children,
  );
}

/// The caption of an [ArcaneFieldSet].
class ArcaneFieldLegend extends StatelessWidget {
  final String text;
  final FieldLegendVariant variant;
  final List<String>? classes;
  final ArcaneStyleData? styles;

  const ArcaneFieldLegend(
    this.text, {
    this.variant = FieldLegendVariant.legend,
    this.classes,
    this.styles,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Component.element(
    tag: 'legend',
    classes: cx(<String?>['arcane-field-legend', ...?classes]),
    attributes: <String, String>{
      'data-slot': 'field-legend',
      'data-variant': variant.name,
    },
    styles: _styles(const <String, String>{}, styles),
    children: <Widget>[Component.text(text)],
  );
}

/// A rule between fields, with optional text such as "or" on it.
class ArcaneFieldSeparator extends StatelessWidget {
  final String? text;
  final List<String>? classes;

  const ArcaneFieldSeparator({this.text, this.classes, super.key});

  @override
  Widget build(BuildContext context) => dom.div(
    classes: cx(<String?>['arcane-field-separator', ...?classes]),
    attributes: <String, String>{
      'data-slot': 'field-separator',
      'data-content': '${text != null}',
    },
    <Widget>[
      const dom.div(
        classes: 'arcane-field-separator-line',
        attributes: <String, String>{'aria-hidden': 'true'},
        <Widget>[],
      ),
      if (text != null)
        dom.span(
          classes: 'arcane-field-separator-content',
          attributes: const <String, String>{
            'data-slot': 'field-separator-content',
          },
          <Widget>[Component.text(text!)],
        ),
    ],
  );
}

dom.Styles? _styles(Map<String, String> own, ArcaneStyleData? styles) {
  final Map<String, String> raw = <String, String>{...own, ...?styles?.toMap()};
  return raw.isEmpty ? null : dom.Styles(raw: raw);
}
