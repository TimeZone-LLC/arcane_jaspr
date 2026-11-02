import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/accordion_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/decoration_styles.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

class NeubrutalismAccordion extends StatelessComponent {
  const NeubrutalismAccordion(this.props, {super.key});

  final AccordionProps props;

  @override
  Component build(BuildContext context) {
    final String group = 'nb-accordion-${identityHashCode(this)}';
    final int? initialOpen = props.openItems.isEmpty
        ? null
        : props.openItems.reduce(
            (int first, int second) => first < second ? first : second,
          );
    return dom.div(
      classes: 'neubrutalism-accordion',
      styles: dom.Styles(
        raw: layerStyles(
          const <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0',
            'width': '100%',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            neubrutalismDecorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        for (int index = 0; index < props.items.length; index++)
          Component.element(
            tag: 'details',
            attributes: <String, String>{
              if (!props.allowMultiple) 'name': group,
              if (props.allowMultiple
                  ? props.openItems.contains(index)
                  : index == initialOpen)
                'open': '',
            },
            children: <Component>[
              Component.element(
                tag: 'summary',
                children: <Component>[
                  dom.span(classes: 'neubrutalism-accordion-title', <Component>[
                    Component.text(props.items[index].title),
                  ]),
                  if (props.variant == AccordionVariant.faq &&
                      props.items[index].category != null)
                    dom.span(
                      classes: 'neubrutalism-accordion-category',
                      styles: dom.Styles(
                        raw: <String, String>{
                          if (props.items[index].accentColor ??
                                  props.defaultAccentColor
                              case final String accent)
                            'background-color': accent,
                        },
                      ),
                      <Component>[Component.text(props.items[index].category!)],
                    ),
                  dom.span(
                    classes: 'faq-chevron neubrutalism-accordion-chevron',
                    attributes: const <String, String>{'aria-hidden': 'true'},
                    <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
                  ),
                ],
              ),
              dom.div(classes: 'neubrutalism-accordion-content', <Component>[
                props.items[index].customContent ??
                    Component.text(props.items[index].content),
              ]),
            ],
          ),
      ],
    );
  }
}
