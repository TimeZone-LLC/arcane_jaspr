import 'dart:async';

import 'package:arcane_jaspr/flutter.dart';

/// Abstract base class for form field providers.
abstract class ArcaneFieldProvider<T> {
  ArcaneFieldProvider({required this.defaultValue});

  final T defaultValue;
  final StreamController<T> _controller = StreamController<T>.broadcast();
  T? _currentValue;

  Stream<T> get stream => _controller.stream;
  T get currentValue => _currentValue ?? defaultValue;

  Future<T> onGetValue(String k);
  Future<void> onSetValue(String k, T value);

  Future<T> getValue(String k) async {
    try {
      final value = await onGetValue(k);
      _currentValue = value;
      if (!_controller.isClosed) {
        _controller.add(value);
      }
      return value;
    } catch (_) {
      return defaultValue;
    }
  }

  Future<void> setValue(String k, T value) async {
    await onSetValue(k, value);
    _currentValue = value;
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }

  void dispose() {
    _controller.close();
  }
}

/// Field provider using nested Map storage with dot notation access.
class ArcaneFieldMapProvider<T> extends ArcaneFieldProvider<T> {
  final Map<String, dynamic> storage;

  ArcaneFieldMapProvider({required super.defaultValue, required this.storage});

  @override
  Future<T> onGetValue(String k) async {
    final List<String> parts = k.split('.');
    Map<String, dynamic> current = storage;
    for (int i = 0; i < parts.length; i++) {
      final String part = parts[i];

      if (i == parts.length - 1) {
        if (current.containsKey(part)) {
          return current[part] as T;
        } else {
          throw Exception("Key not found: $k");
        }
      } else {
        if (current[part] is Map<String, dynamic>) {
          current = current[part] as Map<String, dynamic>;
        } else {
          throw Exception("Key not found: $k");
        }
      }
    }

    throw Exception("Key not found: $k");
  }

  @override
  Future<void> onSetValue(String k, T value) async {
    final List<String> parts = k.split('.');
    Map<String, dynamic> current = storage;
    for (int i = 0; i < parts.length; i++) {
      final String part = parts[i];
      if (i == parts.length - 1) {
        current[part] = value;
      } else {
        current[part] ??= <String, dynamic>{};
        current = current[part] as Map<String, dynamic>;
      }
    }
  }
}

/// Field provider delegating to custom getter/setter functions.
class ArcaneFieldDirectProvider<T> extends ArcaneFieldProvider<T> {
  final Future<T> Function(String) getter;
  final Future<void> Function(String, T) setter;

  ArcaneFieldDirectProvider({
    required super.defaultValue,
    required this.getter,
    required this.setter,
  });

  @override
  Future<T> onGetValue(String k) => getter(k);

  @override
  Future<void> onSetValue(String k, T value) => setter(k, value);
}

/// Form context data for accessing form state.
class ArcaneFormContext {
  final Map<String, dynamic> values;
  final Map<String, String?> errors;
  final void Function(String key, dynamic value) setValue;
  final void Function(String key, String? error) setError;
  final void Function() submit;
  final bool isValid;

  const ArcaneFormContext({
    required this.values,
    required this.errors,
    required this.setValue,
    required this.setError,
    required this.submit,
    required this.isValid,
  });
}

/// Form provider component that manages form state.
class ArcaneFormProvider extends StatefulWidget {
  final Map<String, dynamic> initialValues;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final Map<String, String?> Function(Map<String, dynamic> values)? validator;
  final Widget Function(ArcaneFormContext context) builder;

  const ArcaneFormProvider({
    this.initialValues = const {},
    this.onSubmit,
    this.validator,
    required this.builder,
    super.key,
  });

  @override
  State<ArcaneFormProvider> createState() => _ArcaneFormProviderState();
}

class _ArcaneFormProviderState extends State<ArcaneFormProvider> {
  late Map<String, dynamic> _values;
  Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues);
  }

  void _setValue(String key, dynamic value) {
    setState(() {
      _values[key] = value;
      _errors[key] = null;
    });
  }

  void _setError(String key, String? error) {
    setState(() {
      _errors[key] = error;
    });
  }

  bool get _isValid => !_errors.values.any((e) => e != null);

  void _submit() {
    if (widget.validator != null) {
      final validationErrors = widget.validator!(_values);
      setState(() {
        _errors = validationErrors;
      });

      if (validationErrors.values.any((e) => e != null)) {
        return;
      }
    }

    widget.onSubmit?.call(_values);
  }

  @override
  Widget build(BuildContext context) {
    final formContext = ArcaneFormContext(
      values: _values,
      errors: _errors,
      setValue: _setValue,
      setError: _setError,
      submit: _submit,
      isValid: _isValid,
    );

    return widget.builder(formContext);
  }
}

/// Inherited component to provide form context to descendants.
class ArcaneFormScope extends InheritedWidget {
  final ArcaneFormContext formContext;

  const ArcaneFormScope({
    required this.formContext,
    required super.child,
    super.key,
  });

  static ArcaneFormContext? of(BuildContext context) {
    final scope = context
        .dependOnInheritedComponentOfExactType<ArcaneFormScope>();
    return scope?.formContext;
  }

  @override
  bool updateShouldNotify(covariant ArcaneFormScope oldComponent) {
    return formContext != oldComponent.formContext;
  }
}
