import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/flow_props.dart';
import 'package:arcane_jaspr/core/props/gutter_props.dart';
import 'package:arcane_jaspr/util/arcane.dart';

/// Neubrutalism Row renderer.
class NeubrutalismRow extends StatelessComponent {
  final RowProps props;

  const NeubrutalismRow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-row',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'row',
          'align-items': _crossAlign(props.crossAxisAlignment),
          'justify-content': _mainAlign(props.mainAxisAlignment),
          'width': props.mainAxisSize == MainAxisSize.min
              ? 'fit-content'
              : '100%',
          if (props.gap > 0) 'gap': '${props.gap}px',
        },
      ),
      props.children,
    );
  }
}

/// Neubrutalism Column renderer.
class NeubrutalismColumn extends StatelessComponent {
  final ColumnProps props;

  const NeubrutalismColumn(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-column',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'column',
          'align-items': _crossAlign(props.crossAxisAlignment),
          'justify-content': _mainAlign(props.mainAxisAlignment),
          'height': props.mainAxisSize == MainAxisSize.min
              ? 'fit-content'
              : '100%',
          if (props.gap > 0) 'gap': '${props.gap}px',
        },
      ),
      props.children,
    );
  }
}

/// Neubrutalism Center renderer.
class NeubrutalismCenter extends StatelessComponent {
  final CenterProps props;

  const NeubrutalismCenter(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-center',
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

/// Neubrutalism Spacer renderer.
class NeubrutalismSpacer extends StatelessComponent {
  final SpacerProps props;

  const NeubrutalismSpacer(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-spacer',
      styles: dom.Styles(raw: {'flex': '${props.flex}'}),
      [],
    );
  }
}

/// Neubrutalism Expanded renderer.
class NeubrutalismExpanded extends StatelessComponent {
  final ExpandedProps props;

  const NeubrutalismExpanded(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-expanded',
      styles: dom.Styles(
        raw: {'flex': '${props.flex}', 'min-width': '0', 'min-height': '0'},
      ),
      [props.child],
    );
  }
}

/// Neubrutalism SizedBox renderer.
class NeubrutalismSizedBox extends StatelessComponent {
  final SizedBoxProps props;

  const NeubrutalismSizedBox(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-sized-box',
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

/// Neubrutalism Flow (wrap) renderer.
class NeubrutalismFlow extends StatelessComponent {
  final FlowProps props;

  const NeubrutalismFlow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-flow',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-wrap': 'wrap',
          if (props.direction == Axis.vertical) 'height': '100%',
          'flex-direction': props.direction == Axis.horizontal
              ? (props.reverse ? 'row-reverse' : 'row')
              : (props.reverse ? 'column-reverse' : 'column'),
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

/// Neubrutalism Gap renderer.
class NeubrutalismGap extends StatelessComponent {
  final GapProps props;

  const NeubrutalismGap(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-gap',
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

/// Neubrutalism PaddingWrapper renderer.
class NeubrutalismPaddingWrapper extends StatelessComponent {
  final PaddingWrapperProps props;

  const NeubrutalismPaddingWrapper(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-padding-wrapper',
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
