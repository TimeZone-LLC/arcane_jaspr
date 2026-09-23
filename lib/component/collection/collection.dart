import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class Collection extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final bool fillWidth;

  const Collection({
    this.children = const <Widget>[],
    this.gap = 16,
    this.fillWidth = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: fillWidth
        ? CrossAxisAlignment.stretch
        : CrossAxisAlignment.start,
    spacing: gap,
    children: children,
  );
}
