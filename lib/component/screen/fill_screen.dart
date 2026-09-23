import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/layout/gutter.dart';
import 'package:arcane_jaspr/component/screen/abstract_screen.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class FillScreen extends AbstractStatelessScreen {
  final Widget child;
  final Widget? sidebar;

  const FillScreen({
    required this.child,
    this.sidebar,
    super.header,
    super.footer,
    super.fab,
    super.foreground,
    super.background,
    super.gutter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget body = gutter
        ? Padding(padding: const EdgeInsets.all(24), child: child)
        : child;

    final Widget main = Stack(
      children: <Widget>[
        ?background,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ?header,
            Expanded(child: body),
            ?footer,
          ],
        ),
        ?foreground,
        if (fab != null) Positioned(right: 16, bottom: 16, child: fab!),
      ],
    );

    if (sidebar == null) {
      return main;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        sidebar!,
        Expanded(child: main),
      ],
    );
  }
}
