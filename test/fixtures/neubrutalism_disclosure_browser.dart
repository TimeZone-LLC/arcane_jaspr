import 'package:arcane_jaspr/arcane_jaspr.dart' hide runApp;
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/client.dart' show runApp;
import 'package:jaspr/dom.dart' as dom;
import 'package:web/web.dart' as web;

void main() {
  final String query = web.window.location.search;
  runApp(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(
        variant: query.contains('comic')
            ? NeubrutalismVariant.neuComic
            : NeubrutalismVariant.classic,
        rounded: query.contains('rounded'),
      ),
      brightness: query.contains('dark') ? Brightness.dark : Brightness.light,
      includeFallbackScripts: false,
      home: const dom.div(
        styles: dom.Styles(
          raw: <String, String>{
            'margin': '24px',
            'display': 'grid',
            'gap': '24px',
            'max-width': '480px',
          },
        ),
        <Widget>[
          dom.button(id: 'before', type: dom.ButtonType.button, <Widget>[
            Text('Before'),
          ]),
          ArcaneAccordion(
            bordered: true,
            items: <ArcaneAccordionItem>[
              ArcaneAccordionItem(
                title: 'What is a proof print?',
                content:
                    'A single test sheet used to check color and registration.',
                defaultOpen: true,
              ),
              ArcaneAccordionItem(
                title: 'When should I number prints?',
                content: 'Once the ink is dry and the final run is checked.',
              ),
            ],
          ),
          ArcaneDisclosure(
            summary: Text('Paper care'),
            child: Text('Keep uncoated paper flat and dry.'),
          ),
          ArcaneDisclosureGroup(
            initialOpenIndex: 0,
            items: <ArcaneDisclosureItem>[
              ArcaneDisclosureItem(
                summary: Text('Ink cleanup'),
                content: Text(
                  'Use the cleaning materials recommended for your ink.',
                ),
              ),
              ArcaneDisclosureItem(
                summary: Text('Drying rack'),
                content: Text('Leave space between wet prints.'),
              ),
            ],
          ),
          dom.div(id: 'multiple', <Widget>[
            ArcaneAccordion.faq(
              items: <ArcaneAccordionItem>[
                ArcaneAccordionItem(
                  title: 'Printing',
                  category: 'Studio',
                  content: 'Check the proof.',
                ),
                ArcaneAccordionItem(
                  title: 'Drying',
                  category: 'Paper',
                  content: 'Leave room.',
                ),
              ],
            ),
          ]),
        ],
      ),
    ),
  );
}
