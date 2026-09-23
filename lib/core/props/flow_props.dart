import 'package:arcane_jaspr/flutter.dart';

import 'package:arcane_jaspr/util/arcane.dart';

/// Flow layout component properties.
class FlowProps {
  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final WrapAlignment wrapAlignment;
  final double gap;
  final double? rowGap;
  final double? columnGap;
  final bool reverse;

  const FlowProps({
    required this.children,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.gap = 8,
    this.rowGap,
    this.columnGap,
    this.reverse = false,
  });
}

/// Row layout component properties.
class RowProps {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double gap;

  const RowProps({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.gap = 0,
  });
}

/// Column layout component properties.
class ColumnProps {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double gap;

  const ColumnProps({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.max,
    this.gap = 0,
  });
}

/// Center alignment component properties.
class CenterProps {
  final Widget child;

  const CenterProps({required this.child});
}

/// Spacer component properties.
class SpacerProps {
  final int flex;

  const SpacerProps({this.flex = 1});
}

/// Expanded component properties.
class ExpandedProps {
  final Widget child;
  final int flex;

  const ExpandedProps({required this.child, this.flex = 1});
}

/// SizedBox component properties.
class SizedBoxProps {
  final double? width;
  final double? height;
  final Widget? child;

  const SizedBoxProps({this.width, this.height, this.child});
}

/// Padding wrapper component properties.
class PaddingWrapperProps {
  final EdgeInsets padding;
  final Widget child;

  const PaddingWrapperProps({required this.padding, required this.child});
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for flow/layout components.
mixin FlowRendererContract {
  Widget flow(FlowProps props);
  Widget row(RowProps props);
  Widget column(ColumnProps props);
  Widget center(CenterProps props);
  Widget spacer(SpacerProps props);
  Widget expanded(ExpandedProps props);
  Widget sizedBox(SizedBoxProps props);
  Widget paddingWrapper(PaddingWrapperProps props);
}
