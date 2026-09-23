import 'package:arcane_jaspr/flutter.dart';

/// Keeps generated label and description IDs stable across field rebuilds.
class FieldIdentity extends StatefulWidget {
  final String? id;
  final Widget Function(String id) builder;

  const FieldIdentity({this.id, required this.builder, super.key});

  @override
  State<FieldIdentity> createState() => _FieldIdentityState();
}

class _FieldIdentityState extends State<FieldIdentity> {
  static int _nextId = 0;
  late final String _generatedId = 'arcane-field-${_nextId++}';

  @override
  Widget build(BuildContext context) =>
      widget.builder(widget.id ?? _generatedId);
}
