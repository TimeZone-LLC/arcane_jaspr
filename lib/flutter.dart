library;

import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:meta/meta.dart';

export 'package:jaspr/jaspr.dart'
    show
        AsyncCallback,
        Builder,
        BuildContext,
        Key,
        UniqueKey,
        ValueChanged,
        ValueGetter,
        ValueKey,
        ValueSetter,
        VoidCallback,
        runApp;

typedef Widget = jaspr.Component;

/// A Jaspr state with Flutter's widget access and update lifecycle.
abstract class State<T extends StatefulWidget> extends jaspr.State<T> {
  T get widget => component;

  @override
  @nonVirtual
  void didUpdateComponent(covariant T oldComponent) {
    super.didUpdateComponent(oldComponent);
    didUpdateWidget(oldComponent);
  }

  /// Called after [widget] receives the new configuration and before rebuilding.
  @protected
  @mustCallSuper
  void didUpdateWidget(covariant T oldWidget) {}
}

typedef WidgetBuilder = Widget Function(jaspr.BuildContext context);

typedef IndexedWidgetBuilder =
    Widget Function(jaspr.BuildContext context, int index);

typedef NullableIndexedWidgetBuilder =
    Widget? Function(jaspr.BuildContext context, int index);

abstract class StatelessWidget extends jaspr.StatelessComponent {
  const StatelessWidget({super.key});
}

abstract class StatefulWidget extends jaspr.StatefulComponent {
  const StatefulWidget({super.key});

  @override
  State<StatefulWidget> createState();
}

abstract class InheritedWidget extends jaspr.InheritedComponent {
  const InheritedWidget({required super.child, super.key});
}
