#!/usr/bin/env dart

library;

import 'dart:io';

import 'package:arcane_neon_web/components/demo_registry.dart';

void main(List<String> args) {
  Directory docsAppDirectory = Directory.current;
  File generatorFile = File(
    '${docsAppDirectory.path}/tool/generate_component_catalog.dart',
  );

  if (!generatorFile.existsSync()) {
    stderr.writeln(
      'Run this script from arcane_jaspr_docs/arcane_jaspr_docs_web.',
    );
    exit(1);
  }

  Directory packageRootDirectory = Directory('${docsAppDirectory.path}/../..');
  File mainSurfaceFile = File(
    '${packageRootDirectory.path}/lib/arcane_jaspr.dart',
  );
  File htmlSurfaceFile = File(
    '${packageRootDirectory.path}/lib/component/html/index.dart',
  );
  File outputFile = File(
    '${docsAppDirectory.path}/content/docs/components-catalog.md',
  );

  List<String> mainExports = _readExportPaths(mainSurfaceFile);
  List<String> componentExports = _filterByPrefix(mainExports, 'component/');
  List<String> foundationExports = _excludeByPrefix(mainExports, 'component/');
  List<String> htmlExports = _readExportPaths(htmlSurfaceFile);

  Set<String> liveDemoSources = <String>{
    for (DemoDefinition demo in demoDefinitions)
      _normalizeMainSurfacePath(demo.sourcePath),
  };

  List<_CatalogEntry> liveDemoEntries = <_CatalogEntry>[
    for (DemoDefinition demo in demoDefinitions)
      _CatalogEntry(
        symbolName: demo.symbolName,
        sourcePath: demo.sourcePath,
        componentType: demo.componentType,
      ),
  ];
  List<_CatalogEntry> supportEntries = _buildEntries(
    packageRootDirectory: packageRootDirectory,
    exportPaths: <String>[
      for (String exportPath in componentExports)
        if (!liveDemoSources.contains(exportPath)) exportPath,
    ],
    includeComponentType: false,
  );
  List<_CatalogEntry> foundationEntries = _buildEntries(
    packageRootDirectory: packageRootDirectory,
    exportPaths: foundationExports,
    includeComponentType: false,
  );
  List<_CatalogEntry> htmlEntries = _buildEntries(
    packageRootDirectory: packageRootDirectory,
    exportPaths: <String>[
      for (String exportPath in htmlExports) 'component/html/$exportPath',
    ],
    includeComponentType: false,
  );

  String markdown = _buildMarkdown(
    liveDemoEntries: liveDemoEntries,
    supportEntries: supportEntries,
    foundationEntries: foundationEntries,
    htmlEntries: htmlEntries,
    mainSurfaceCount: mainExports.length,
  );

  outputFile.writeAsStringSync(markdown);
  stdout.writeln('Generated ${outputFile.path}');
}

List<String> _readExportPaths(File sourceFile) {
  String content = sourceFile.readAsStringSync();
  RegExp exportPattern = RegExp(r"export '([^']+)'");

  return <String>[
    for (RegExpMatch match in exportPattern.allMatches(content))
      match.group(1)!,
  ];
}

List<String> _filterByPrefix(List<String> values, String prefix) {
  return <String>[
    for (String value in values)
      if (value.startsWith(prefix)) value,
  ];
}

List<String> _excludeByPrefix(List<String> values, String prefix) {
  return <String>[
    for (String value in values)
      if (!value.startsWith(prefix)) value,
  ];
}

String _normalizeMainSurfacePath(String sourcePath) {
  return sourcePath.replaceFirst('lib/', '');
}

List<_CatalogEntry> _buildEntries({
  required Directory packageRootDirectory,
  required List<String> exportPaths,
  required bool includeComponentType,
}) {
  List<_CatalogEntry> entries = <_CatalogEntry>[];

  for (String exportPath in exportPaths) {
    File sourceFile = File('${packageRootDirectory.path}/lib/$exportPath');
    String symbolName = _readPrimarySymbolName(sourceFile);
    String sourcePath = 'lib/$exportPath';
    String componentType = _componentTypeForSource(sourcePath);

    entries.add(
      _CatalogEntry(
        symbolName: symbolName,
        sourcePath: sourcePath,
        componentType: includeComponentType ? componentType : null,
      ),
    );
  }

  entries.sort(_compareEntries);
  return entries;
}

String _readPrimarySymbolName(File sourceFile) {
  String content = sourceFile.readAsStringSync();
  List<RegExp> patterns = <RegExp>[
    RegExp(r'class\s+([A-Z][A-Za-z0-9_]*)'),
    RegExp(r'enum\s+([A-Z][A-Za-z0-9_]*)'),
    RegExp(r'typedef\s+([A-Z][A-Za-z0-9_]*)'),
    RegExp(r'mixin\s+([A-Z][A-Za-z0-9_]*)'),
  ];

  for (RegExp pattern in patterns) {
    RegExpMatch? match = pattern.firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }
  }

  String fileName = sourceFile.uri.pathSegments.last;
  return fileName.replaceAll('.dart', '');
}

int _compareEntries(_CatalogEntry left, _CatalogEntry right) {
  return left.sourcePath.compareTo(right.sourcePath);
}

String _componentTypeForSource(String sourcePath) {
  for (DemoDefinition demo in demoDefinitions) {
    if (demo.sourcePath == sourcePath) {
      return demo.componentType;
    }
  }

  return '';
}

String _buildMarkdown({
  required List<_CatalogEntry> liveDemoEntries,
  required List<_CatalogEntry> supportEntries,
  required List<_CatalogEntry> foundationEntries,
  required List<_CatalogEntry> htmlEntries,
  required int mainSurfaceCount,
}) {
  DateTime now = DateTime.now();
  String generatedDate = _formatDate(now);
  List<String> lines = <String>[];

  lines.add('---');
  lines.add('title: Component Catalog');
  lines.add(
    'description: Generated Arcane Jaspr surface catalog for the Flutter-first primary import and advanced HTML escape hatch',
  );
  lines.add('layout: kb');
  lines.add('---');
  lines.add('');
  lines.add('# Component Catalog');
  lines.add('');
  lines.add(
    'This page combines the live demo registry with the current `package:arcane_jaspr/arcane_jaspr.dart` and `package:arcane_jaspr/html.dart` exports. Try every live example in the [Ascii component lab](/ascii#component-lab); examples outside the primary import include their module import.',
  );
  lines.add('');
  lines.add('## Snapshot');
  lines.add('');
  lines.add('- Generated on `$generatedDate`');
  lines.add('- Live component demos: `${liveDemoEntries.length}`');
  lines.add('- Primary support component modules: `${supportEntries.length}`');
  lines.add('- Main-surface foundation exports: `${foundationEntries.length}`');
  lines.add('- Total main-surface export modules: `$mainSurfaceCount`');
  lines.add('- Advanced HTML modules: `${htmlEntries.length}`');
  lines.add('');
  lines.add(
    'Use `package:arcane_jaspr/arcane_jaspr.dart` for the Flutter-first surface. Use `package:arcane_jaspr/html.dart` and `package:arcane_jaspr/web.dart` only when you intentionally need lower-level HTML or raw Jaspr escape hatches.',
  );
  lines.add('');
  lines.add('## Live Components (${liveDemoEntries.length})');
  lines.add('');
  lines.add('| Component | Symbol | Source |');
  lines.add('|---|---|---|');

  for (_CatalogEntry entry in liveDemoEntries) {
    lines.add(
      '| `${entry.componentType}` | `${entry.symbolName}` | `${entry.sourcePath}` |',
    );
  }

  lines.add('');
  lines.add('## Primary Support Modules (${supportEntries.length})');
  lines.add('');
  lines.add('| Symbol | Source |');
  lines.add('|---|---|');

  for (_CatalogEntry entry in supportEntries) {
    lines.add('| `${entry.symbolName}` | `${entry.sourcePath}` |');
  }

  lines.add('');
  lines.add('## Main-Surface Foundation Exports (${foundationEntries.length})');
  lines.add('');
  lines.add('| Symbol | Source |');
  lines.add('|---|---|');

  for (_CatalogEntry entry in foundationEntries) {
    lines.add('| `${entry.symbolName}` | `${entry.sourcePath}` |');
  }

  lines.add('');
  lines.add('## Advanced HTML Modules (${htmlEntries.length})');
  lines.add('');
  lines.add('| Symbol | Source |');
  lines.add('|---|---|');

  for (_CatalogEntry entry in htmlEntries) {
    lines.add('| `${entry.symbolName}` | `${entry.sourcePath}` |');
  }

  lines.add('');

  return '${lines.join('\n')}\n';
}

String _formatDate(DateTime value) {
  List<String> monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String monthName = monthNames[value.month - 1];
  return '$monthName ${value.day}, ${value.year}';
}

class _CatalogEntry {
  final String symbolName;
  final String sourcePath;
  final String? componentType;

  const _CatalogEntry({
    required this.symbolName,
    required this.sourcePath,
    this.componentType,
  });
}
