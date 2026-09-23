import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/flow_props.dart';
import 'package:arcane_jaspr/core/props/gutter_props.dart';
import 'package:arcane_jaspr/util/arcane.dart';

/// Neon Row renderer.
class NeonRow extends StatelessComponent {
  final RowProps props;

  const NeonRow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-row',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'row',
          'align-items': _crossAlign(props.crossAxisAlignment),
          'justify-content': _mainAlign(props.mainAxisAlignment),
          'width': props.mainAxisSize == MainAxisSize.max
              ? '100%'
              : 'fit-content',
          if (props.gap > 0) 'gap': '${props.gap}px',
        },
      ),
      props.children,
    );
  }
}

/// Neon Column renderer.
class NeonColumn extends StatelessComponent {
  final ColumnProps props;

  const NeonColumn(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-column',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'column',
          'align-items': _crossAlign(props.crossAxisAlignment),
          'justify-content': _mainAlign(props.mainAxisAlignment),
          'height': props.mainAxisSize == MainAxisSize.max
              ? '100%'
              : 'fit-content',
          if (props.gap > 0) 'gap': '${props.gap}px',
        },
      ),
      props.children,
    );
  }
}

/// Neon Center renderer.
class NeonCenter extends StatelessComponent {
  final CenterProps props;

  const NeonCenter(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-center',
      styles: const dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '100%',
          'height': '100%',
        },
      ),
      [props.child],
    );
  }
}

/// Neon Spacer renderer.
class NeonSpacer extends StatelessComponent {
  final SpacerProps props;

  const NeonSpacer(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-spacer',
      styles: dom.Styles(raw: {'flex': '${props.flex}'}),
      [],
    );
  }
}

/// Neon Expanded renderer.
class NeonExpanded extends StatelessComponent {
  final ExpandedProps props;

  const NeonExpanded(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-expanded',
      styles: dom.Styles(
        raw: {'flex': '${props.flex}', 'min-width': '0', 'min-height': '0'},
      ),
      [props.child],
    );
  }
}

/// Neon SizedBox renderer.
class NeonSizedBox extends StatelessComponent {
  final SizedBoxProps props;

  const NeonSizedBox(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-sized-box',
      styles: dom.Styles(
        raw: {
          if (props.width != null)
            'width': props.width == double.infinity
                ? '100%'
                : '${props.width}px',
          if (props.height != null)
            'height': props.height == double.infinity
                ? '100%'
                : '${props.height}px',
          'flex-shrink': '0',
        },
      ),
      props.child != null ? [props.child!] : [],
    );
  }
}

/// Neon Flow (wrap) renderer.
class NeonFlow extends StatelessComponent {
  final FlowProps props;

  const NeonFlow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-flow',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-wrap': 'wrap',
          if (props.direction == Axis.vertical) 'height': '100%',
          'flex-direction': props.direction == Axis.vertical
              ? (props.reverse ? 'column-reverse' : 'column')
              : (props.reverse ? 'row-reverse' : 'row'),
          'align-items': _crossAlign(props.crossAxisAlignment),
          'justify-content': _mainAlign(props.mainAxisAlignment),
          'align-content': _wrapAlign(props.wrapAlignment),
          'gap':
              '${props.rowGap ?? props.gap}px ${props.columnGap ?? props.gap}px',
        },
      ),
      props.children,
    );
  }
}

/// Neon Gap renderer.
class NeonGap extends StatelessComponent {
  final GapProps props;

  const NeonGap(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-gap',
      styles: dom.Styles(
        raw: {
          if (props.horizontal)
            'width': '${props.size}px'
          else
            'height': '${props.size}px',
          'flex-shrink': '0',
        },
      ),
      [],
    );
  }
}

/// Neon PaddingWrapper renderer.
class NeonPaddingWrapper extends StatelessComponent {
  final PaddingWrapperProps props;

  const NeonPaddingWrapper(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neon-padding-wrapper',
      styles: dom.Styles(
        raw: {
          'padding':
              '${props.padding.top}px ${props.padding.right}px ${props.padding.bottom}px ${props.padding.left}px',
        },
      ),
      [props.child],
    );
  }
}

// Helper functions
String _mainAlign(MainAxisAlignment alignment) {
  return switch (alignment) {
    MainAxisAlignment.start => 'flex-start',
    MainAxisAlignment.end => 'flex-end',
    MainAxisAlignment.center => 'center',
    MainAxisAlignment.spaceBetween => 'space-between',
    MainAxisAlignment.spaceAround => 'space-around',
    MainAxisAlignment.spaceEvenly => 'space-evenly',
  };
}

String _crossAlign(CrossAxisAlignment alignment) {
  return switch (alignment) {
    CrossAxisAlignment.start => 'flex-start',
    CrossAxisAlignment.end => 'flex-end',
    CrossAxisAlignment.center => 'center',
    CrossAxisAlignment.stretch => 'stretch',
    CrossAxisAlignment.baseline => 'baseline',
  };
}

String _wrapAlign(WrapAlignment alignment) {
  return switch (alignment) {
    WrapAlignment.start => 'flex-start',
    WrapAlignment.end => 'flex-end',
    WrapAlignment.center => 'center',
    WrapAlignment.spaceBetween => 'space-between',
    WrapAlignment.spaceAround => 'space-around',
    WrapAlignment.spaceEvenly => 'space-evenly',
  };
}
