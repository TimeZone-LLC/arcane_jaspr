import 'package:arcane_jaspr/component/screen/abstract_screen.dart';
import 'package:arcane_jaspr/component/screen/fill_screen.dart';
import 'package:arcane_jaspr/flutter.dart';

class SliverScreen extends AbstractStatefulScreen {
  final Widget sliver;
  final Widget? sidebar;

  const SliverScreen({
    required this.sliver,
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
  State<SliverScreen> createState() => _SliverScreenState();
}

class _SliverScreenState extends State<SliverScreen> {
  @override
  Widget build(BuildContext context) => FillScreen(
    sidebar: widget.sidebar,
    header: widget.header,
    footer: widget.footer,
    fab: widget.fab,
    foreground: widget.foreground,
    background: widget.background,
    gutter: widget.gutter,
    child: widget.sliver,
  );
}
