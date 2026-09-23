import '../../core/dom_value.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
import 'package:jaspr/dom.dart'
    hide
        Color,
        Colors,
        ColorScheme,
        Gap,
        Padding,
        TextAlign,
        TextOverflow,
        Border,
        BorderRadius,
        BoxShadow,
        FontWeight;

import 'provider.dart';

/// Metadata for an ArcaneField.
class ArcaneFieldMetadata {
  final String? key;
  final String? name;
  final String? description;
  final String? icon;
  final String? placeholder;

  const ArcaneFieldMetadata({
    this.name,
    this.key,
    this.icon,
    this.description,
    this.placeholder,
  });

  String get effectiveKey =>
      key ??
      name?.toLowerCase().replaceAll(' ', '_').replaceAll("/", ".") ??
      "no_key";
}

/// Generic form field component with provider-based state management.
class ArcaneField<T> extends StatefulWidget {
  final ArcaneFieldMetadata meta;
  final ArcaneFieldProvider<T> provider;
  final Widget Function(
    BuildContext context,
    T value,
    void Function(T) onChanged,
  )
  builder;

  Type get dataRuntimeType => T;

  const ArcaneField({
    required this.meta,
    required this.provider,
    required this.builder,
    super.key,
  });

  @override
  State<ArcaneField<T>> createState() => _ArcaneFieldState<T>();
}

class _ArcaneFieldState<T> extends State<ArcaneField<T>> {
  late T _value;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _value = widget.provider.defaultValue;
    // Only resolve the async value on the client. During SSR the await
    // continuation in _loadValue would call setState() after the synchronous
    // build phase, tripping jaspr's "setState during build" assertion. On the
    // server _loading stays true so the loading placeholder renders, which
    // matches the client's first build for clean hydration; the client then
    // runs _loadValue() to populate the real value.
    if (kIsWeb) {
      _loadValue();
    }
  }

  Future<void> _loadValue() async {
    final T value = await widget.provider.getValue(widget.meta.effectiveKey);
    setState(() {
      _value = value;
      _loading = false;
    });
  }

  void _handleChange(T newValue) {
    setState(() {
      _value = newValue;
    });
    widget.provider.setValue(widget.meta.effectiveKey, newValue);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const div(styles: Styles(raw: {'opacity': '0.5'}), [
        Component.text('Loading...'),
      ]);
    }

    return widget.builder(context, _value, _handleChange);
  }
}

/// Factory class for creating common field types.
class ArcaneInput {
  const ArcaneInput._();

  static ArcaneField<String> textField({
    String? name,
    String? description,
    String? icon,
    String? placeholder,
    int? minLines,
    int? maxLines,
    String defaultValue = "",
    required Future<String> Function() getter,
    required Future<void> Function(String) setter,
  }) => ArcaneField<String>(
    meta: ArcaneFieldMetadata(
      name: name,
      description: description,
      icon: icon,
      placeholder: placeholder,
    ),
    provider: ArcaneFieldDirectProvider(
      defaultValue: defaultValue,
      getter: (_) => getter(),
      setter: (_, v) => setter(v),
    ),
    builder: (context, value, onChanged) => _StringFieldBuilder(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder,
      minLines: minLines,
      maxLines: maxLines,
    ),
  );

  static ArcaneField<String> textArea({
    String? name,
    String? description,
    String? icon,
    String? placeholder,
    int minLines = 3,
    int maxLines = 6,
    String defaultValue = "",
    required Future<String> Function() getter,
    required Future<void> Function(String) setter,
  }) => textField(
    name: name,
    description: description,
    icon: icon,
    placeholder: placeholder,
    minLines: minLines,
    maxLines: maxLines,
    defaultValue: defaultValue,
    getter: getter,
    setter: setter,
  );

  static ArcaneField<bool> checkbox({
    String? name,
    String? description,
    String? icon,
    bool defaultValue = false,
    required Future<bool> Function() getter,
    required Future<void> Function(bool) setter,
  }) => ArcaneField<bool>(
    meta: ArcaneFieldMetadata(name: name, description: description, icon: icon),
    provider: ArcaneFieldDirectProvider(
      defaultValue: defaultValue,
      getter: (_) => getter(),
      setter: (_, v) => setter(v),
    ),
    builder: (context, value, onChanged) =>
        _BoolFieldBuilder(value: value, onChanged: onChanged, labelText: name),
  );

  static ArcaneField<T> select<T>({
    String? name,
    String? description,
    String? icon,
    required T defaultValue,
    required List<T> options,
    required Future<T> Function() getter,
    required Future<void> Function(T) setter,
    String Function(T)? labelBuilder,
  }) => ArcaneField<T>(
    meta: ArcaneFieldMetadata(name: name, description: description, icon: icon),
    provider: ArcaneFieldDirectProvider(
      defaultValue: defaultValue,
      getter: (_) => getter(),
      setter: (_, v) => setter(v),
    ),
    builder: (context, value, onChanged) => _SelectFieldBuilder<T>(
      value: value,
      options: options,
      onChanged: onChanged,
      labelBuilder: labelBuilder ?? (v) => v.toString(),
    ),
  );
}

class _StringFieldBuilder extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;
  final String? placeholder;
  final int? minLines;
  final int? maxLines;

  const _StringFieldBuilder({
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = (maxLines ?? 1) > 1;

    if (isMultiline) {
      return textarea(
        classes: 'arcane-field-textarea',
        attributes: {
          'placeholder': placeholder ?? '',
          'rows': '${maxLines ?? 3}',
        },
        styles: const Styles(
          raw: {
            'width': '100%',
            'padding': '10px 1rem',
            'border': '1px solid var(--border)',
            'border-radius': '0.375rem',
            'background-color': 'var(--card)',
            'color': 'var(--foreground)',
            'font-size': '0.875rem',
            'resize': 'vertical',
            'font-family': 'inherit',
            'outline': 'none',
          },
        ),
        events: {
          'input': (event) {
            final dynamic target = event.target;
            if (target != null) {
              onChanged(domInputValue(target));
            }
          },
        },
        [Component.text(value)],
      );
    }

    return input(
      type: InputType.text,
      classes: 'arcane-field-input',
      attributes: {'value': value, 'placeholder': placeholder ?? ''},
      styles: const Styles(
        raw: {
          'width': '100%',
          'padding': '10px 1rem',
          'border': '1px solid var(--border)',
          'border-radius': '0.375rem',
          'background-color': 'var(--card)',
          'color': 'var(--foreground)',
          'font-size': '0.875rem',
          'outline': 'none',
        },
      ),
      events: {
        'input': (event) {
          final dynamic target = event.target;
          if (target != null) {
            onChanged(domInputValue(target));
          }
        },
      },
    );
  }
}

class _BoolFieldBuilder extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String? labelText;

  const _BoolFieldBuilder({
    required this.value,
    required this.onChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return label(
      styles: const Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'gap': '0.5rem',
          'cursor': 'pointer',
        },
      ),
      [
        input(
          type: InputType.checkbox,
          attributes: {if (value) 'checked': 'true'},
          styles: const Styles(
            raw: {
              'width': '18px',
              'height': '18px',
              'accent-color': 'var(--accent)',
              'cursor': 'pointer',
            },
          ),
          events: {
            'change': (event) {
              final dynamic target = event.target;
              if (target != null) {
                onChanged(domCheckedValue(target));
              }
            },
          },
        ),
        if (labelText != null)
          span(
            styles: const Styles(
              raw: {'color': 'var(--foreground)', 'font-size': '0.875rem'},
            ),
            [Component.text(labelText!)],
          ),
      ],
    );
  }
}

class _SelectFieldBuilder<T> extends StatelessWidget {
  final T value;
  final List<T> options;
  final void Function(T) onChanged;
  final String Function(T) labelBuilder;

  const _SelectFieldBuilder({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return select(
      classes: 'arcane-field-select',
      styles: const Styles(
        raw: {
          'width': '100%',
          'padding': '10px 1rem',
          'border': '1px solid var(--border)',
          'border-radius': '0.375rem',
          'background-color': 'var(--card)',
          'color': 'var(--foreground)',
          'font-size': '0.875rem',
          'outline': 'none',
          'cursor': 'pointer',
        },
      ),
      events: {
        'change': (event) {
          final dynamic target = event.target;
          if (target != null) {
            final int selectedIndex = domSelectedIndex(target);
            if (selectedIndex >= 0 && selectedIndex < options.length) {
              onChanged(options[selectedIndex]);
            }
          }
        },
      },
      [
        for (int i = 0; i < options.length; i++)
          option(value: i.toString(), selected: options[i] == value, [
            Component.text(labelBuilder(options[i])),
          ]),
      ],
    );
  }
}

class ArcaneFieldStyles {
  ArcaneFieldStyles._();

  @css
  static final List<StyleRule> styles = [
    css('.arcane-field-textarea:focus, .arcane-field-input:focus').styles(
      raw: {
        'border-color': 'var(--accent)',
        'box-shadow':
            '0 0 0 2px color-mix(in srgb, var(--accent) 10%, transparent)',
      },
    ),
    css('.arcane-field-select:focus').styles(
      raw: {
        'border-color': 'var(--accent)',
        'box-shadow':
            '0 0 0 2px color-mix(in srgb, var(--accent) 10%, transparent)',
      },
    ),
  ];
}
