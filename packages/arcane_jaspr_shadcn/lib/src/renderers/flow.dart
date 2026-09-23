import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/flow_props.dart';
import 'package:arcane_jaspr/util/arcane.dart';

/// Renders a flow layout component.
Component renderFlow(FlowProps props) {
  return dom.div(
    classes: 'arcane-flow',
    styles: dom.Styles(
      raw: {
        'display': 'flex',
        'flex-wrap': 'wrap',
        if (props.direction == Axis.vertical) 'height': '100%',
        'flex-direction': props.direction == Axis.vertical
            ? (props.reverse ? 'column-reverse' : 'column')
            : (props.reverse ? 'row-reverse' : 'row'),
        'justify-content': props.mainAxisAlignment.css,
        'align-items': props.crossAxisAlignment.css,
        'align-content': props.wrapAlignment.css,
        'gap':
            '${props.rowGap ?? props.gap}px ${props.columnGap ?? props.gap}px',
      },
    ),
    props.children,
  );
}

/// Renders a row layout component.
Component renderRow(RowProps props) {
  return dom.div(
    classes: 'arcane-row',
    styles: dom.Styles(
      raw: {
        'display': 'flex',
        'flex-direction': 'row',
        'justify-content': props.mainAxisAlignment.css,
        'align-items': props.crossAxisAlignment.css,
        'width': props.mainAxisSize == MainAxisSize.max
            ? '100%'
            : 'fit-content',
        if (props.gap > 0) 'gap': '${props.gap}px',
      },
    ),
    props.children,
  );
}

/// Renders a column layout component.
Component renderColumn(ColumnProps props) {
  return dom.div(
    classes: 'arcane-column',
    styles: dom.Styles(
      raw: {
        'display': 'flex',
        'flex-direction': 'column',
        'justify-content': props.mainAxisAlignment.css,
        'align-items': props.crossAxisAlignment.css,
        'height': props.mainAxisSize == MainAxisSize.max
            ? '100%'
            : 'fit-content',
        if (props.gap > 0) 'gap': '${props.gap}px',
      },
    ),
    props.children,
  );
}

/// Renders a center alignment component.
Component renderCenter(CenterProps props) {
  return dom.div(
    classes: 'arcane-center',
    styles: const dom.Styles(
      raw: {
        'display': 'flex',
        'justify-content': 'center',
        'align-items': 'center',
        'width': '100%',
        'height': '100%',
      },
    ),
    [props.child],
  );
}

/// Renders a spacer component.
Component renderSpacer(SpacerProps props) {
  return dom.div(
    classes: 'arcane-spacer',
    styles: dom.Styles(raw: {'flex': '${props.flex}'}),
    [],
  );
}

/// Renders an expanded component.
Component renderExpanded(ExpandedProps props) {
  return dom.div(
    classes: 'arcane-expanded',
    styles: dom.Styles(
      raw: {'flex': '${props.flex}', 'min-width': '0', 'min-height': '0'},
    ),
    [props.child],
  );
}

/// Renders a sized box component.
Component renderSizedBox(SizedBoxProps props) {
  return dom.div(
    classes: 'arcane-sized-box',
    styles: dom.Styles(
      raw: {
        if (props.width != null)
          'width': props.width == double.infinity ? '100%' : '${props.width}px',
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

/// Renders a padding wrapper component.
Component renderPaddingWrapper(PaddingWrapperProps props) {
  return dom.div(
    classes: 'arcane-padding',
    styles: dom.Styles(raw: {'padding': props.padding.padding}),
    [props.child],
  );
}
