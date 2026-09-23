import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/flow_props.dart';
import 'package:arcane_jaspr/core/props/gutter_props.dart';
import 'package:arcane_jaspr/util/arcane.dart';

/// Win95 Row renderer.
class Win95Row extends StatelessComponent {
  final RowProps props;

  const Win95Row(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-row',
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

/// Win95 Column renderer.
class Win95Column extends StatelessComponent {
  final ColumnProps props;

  const Win95Column(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-column',
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

/// Win95 Center renderer.
class Win95Center extends StatelessComponent {
  final CenterProps props;

  const Win95Center(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-center',
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

/// Win95 Spacer renderer.
class Win95Spacer extends StatelessComponent {
  final SpacerProps props;

  const Win95Spacer(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-spacer',
      styles: dom.Styles(raw: {'flex': '${props.flex}'}),
      [],
    );
  }
}

/// Win95 Expanded renderer.
class Win95Expanded extends StatelessComponent {
  final ExpandedProps props;

  const Win95Expanded(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-expanded',
      styles: dom.Styles(
        raw: {'flex': '${props.flex}', 'min-width': '0', 'min-height': '0'},
      ),
      [props.child],
    );
  }
}

/// Win95 SizedBox renderer.
class Win95SizedBox extends StatelessComponent {
  final SizedBoxProps props;

  const Win95SizedBox(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-sized-box',
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

/// Win95 Flow (wrap) renderer.
class Win95Flow extends StatelessComponent {
  final FlowProps props;

  const Win95Flow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-flow',
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

/// Win95 Gap renderer.
class Win95Gap extends StatelessComponent {
  final GapProps props;

  const Win95Gap(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-gap',
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

/// Win95 PaddingWrapper renderer.
class Win95PaddingWrapper extends StatelessComponent {
  final PaddingWrapperProps props;

  const Win95PaddingWrapper(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'win95-padding-wrapper',
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
