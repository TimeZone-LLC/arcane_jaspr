import 'package:arcane_jaspr/component/card/card.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/component/view/static_table.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class Markdown extends StatelessWidget {
  final String data;

  const Markdown(this.data, {super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 12,
    children: _MarkdownBlockParser.parse(data),
  );
}

class ArcaneTableMd extends StatelessWidget {
  final String text;

  const ArcaneTableMd(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> lines = text
        .split('\n')
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty)
        .toList();

    if (lines.length < 2) {
      return Card.outlined(child: Text.body(text));
    }

    final List<String> headers = _MarkdownBlockParser.splitCells(lines.first);
    final List<List<Widget>> rows = lines.skip(2).map((String line) {
      final List<String> cells = _MarkdownBlockParser.splitCells(line);
      return cells.map((String cell) => Text.body(cell)).toList();
    }).toList();

    return StaticTable(headers: headers, rows: rows);
  }
}

class _MarkdownBlockParser {
  static List<Widget> parse(String data) {
    final List<String> lines = data.replaceAll('\r\n', '\n').split('\n');
    final List<Widget> widgets = <Widget>[];
    final List<String> paragraphLines = <String>[];
    final List<String> listItems = <String>[];
    final List<String> codeLines = <String>[];
    bool inCodeBlock = false;
    int index = 0;

    while (index < lines.length) {
      final String line = lines[index];
      final String trimmed = line.trim();

      if (trimmed.startsWith('```')) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        if (inCodeBlock) {
          widgets.add(Card.outlined(child: Text(codeLines.join('\n'))));
          codeLines.clear();
        }
        inCodeBlock = !inCodeBlock;
        index += 1;
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(line);
        index += 1;
        continue;
      }

      if (isTableHeader(lines, index)) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        final List<String> tableLines = <String>[
          lines[index],
          lines[index + 1],
        ];
        index += 2;
        while (index < lines.length && lines[index].trim().contains('|')) {
          tableLines.add(lines[index]);
          index += 1;
        }
        widgets.add(ArcaneTableMd(tableLines.join('\n')));
        continue;
      }

      if (trimmed.isEmpty) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        index += 1;
        continue;
      }

      if (trimmed.startsWith('# ')) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        widgets.add(Text.pageTitle(trimmed.substring(2)));
        index += 1;
        continue;
      }

      if (trimmed.startsWith('## ')) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        widgets.add(Text.sectionTitle(trimmed.substring(3)));
        index += 1;
        continue;
      }

      if (trimmed.startsWith('### ')) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        widgets.add(Text.heading3(trimmed.substring(4)));
        index += 1;
        continue;
      }

      if (trimmed.startsWith('> ')) {
        _flushParagraph(paragraphLines, widgets);
        _flushList(listItems, widgets);
        widgets.add(Card.ghost(child: Text.body(trimmed.substring(2))));
        index += 1;
        continue;
      }

      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        _flushParagraph(paragraphLines, widgets);
        listItems.add(trimmed.substring(2).trim());
        index += 1;
        continue;
      }

      paragraphLines.add(trimmed);
      index += 1;
    }

    _flushParagraph(paragraphLines, widgets);
    _flushList(listItems, widgets);

    if (inCodeBlock && codeLines.isNotEmpty) {
      widgets.add(Card.outlined(child: Text(codeLines.join('\n'))));
    }

    return widgets;
  }

  static bool isTableHeader(List<String> lines, int index) {
    if (index + 1 >= lines.length) {
      return false;
    }
    final String header = lines[index].trim();
    final String divider = lines[index + 1].trim();
    return header.contains('|') && RegExp(r'^\|?\s*:?[-]+').hasMatch(divider);
  }

  static List<String> splitCells(String line) => line
      .trim()
      .replaceAll(RegExp(r'^\|'), '')
      .replaceAll(RegExp(r'\|$'), '')
      .split('|')
      .map((String cell) => cell.trim())
      .toList();

  static void _flushParagraph(
    List<String> paragraphLines,
    List<Widget> widgets,
  ) {
    if (paragraphLines.isEmpty) {
      return;
    }
    widgets.add(Text.body(paragraphLines.join(' ')));
    paragraphLines.clear();
  }

  static void _flushList(List<String> listItems, List<Widget> widgets) {
    if (listItems.isEmpty) {
      return;
    }
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: listItems
            .map(
              (String item) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: <Widget>[
                  const Text('•'),
                  Expanded(child: Text.body(item)),
                ],
              ),
            )
            .toList(),
      ),
    );
    listItems.clear();
  }
}
