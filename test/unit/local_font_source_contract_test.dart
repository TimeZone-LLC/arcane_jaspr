import 'dart:io';

import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/jaspr_test.dart';

const Set<String> _sourceExtensions = <String>{
  '.css',
  '.cjs',
  '.dart',
  '.htm',
  '.html',
  '.js',
  '.jsx',
  '.json',
  '.less',
  '.md',
  '.mdx',
  '.mjs',
  '.mts',
  '.sass',
  '.scss',
  '.sh',
  '.toml',
  '.ts',
  '.tsx',
  '.xml',
  '.yaml',
  '.yml',
};

const Set<String> _stylesheetExtensions = <String>{
  '.css',
  '.less',
  '.sass',
  '.scss',
};

final RegExp _remoteUrlPattern = RegExp(
  r'''https?://[^\s'"<>\)\]]+''',
  caseSensitive: false,
);

bool _isRemoteFontOrStylesheet(
  Uri uri, {
  bool documentation = false,
  bool stylesheetSource = false,
}) {
  final String host = uri.host.toLowerCase();
  final String path = uri.path.toLowerCase();
  if (host == 'fonts.googleapis.com' || host == 'fonts.gstatic.com') {
    return true;
  }
  if (stylesheetSource) return true;

  const Set<String> forbiddenFontExtensions = <String>{
    '.eot',
    '.otf',
    '.ttf',
    '.woff',
    '.woff2',
  };
  for (final String segment in path.split('/')) {
    if (forbiddenFontExtensions.any(segment.endsWith)) return true;
    if (!documentation && segment.endsWith('.css')) return true;
  }
  return false;
}

Iterable<File> _sourceFiles() sync* {
  for (final String rootPath in <String>[
    'assets',
    'bin',
    'lib',
    'packages',
    'arcane_jaspr_docs',
    'test',
    'tool',
  ]) {
    final Directory root = Directory(rootPath);
    if (!root.existsSync()) continue;
    for (final FileSystemEntity entity in root.listSync(recursive: true)) {
      if (entity is! File) continue;
      final String path = entity.path;
      if (path.contains('/.dart_tool/') ||
          path.contains('/build/') ||
          path.contains('/node_modules/')) {
        continue;
      }
      if (path.endsWith('/web/search-index.json') ||
          path.endsWith('/web/assets/search-index.json')) {
        continue;
      }
      // This document records download provenance for fonts embedded as data URLs.
      if (path == 'packages/arcane_jaspr_neubrutalism/FONT_LICENSES.md') {
        continue;
      }
      if (!_sourceExtensions.any(path.endsWith)) continue;
      yield entity;
    }
  }
}

void main() {
  test('source tree contains no remote font or stylesheet URL', () {
    final List<String> violations = <String>[];
    for (final File file in _sourceFiles()) {
      final String source = file.readAsStringSync();
      for (final RegExpMatch match in _remoteUrlPattern.allMatches(source)) {
        final Uri? uri = Uri.tryParse(match.group(0)!);
        final bool stylesheetSource = _stylesheetExtensions.any(
          file.path.endsWith,
        );
        if (uri != null &&
            _isRemoteFontOrStylesheet(
              uri,
              documentation: file.path.endsWith('.md'),
              stylesheetSource: stylesheetSource,
            )) {
          violations.add('${file.path}:${match.group(0)}');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('unrelated documentation hyperlinks are allowed', () {
    final Uri documentation = Uri.parse(
      '${'https://example.com'}/reference/example.css',
    );
    expect(
      _isRemoteFontOrStylesheet(documentation, documentation: true),
      isFalse,
    );
  });

  test('stylesheet sources reject endpoints without a file extension', () {
    final Uri endpoint = Uri.parse('${'https://example.com'}/font-styles');
    expect(_isRemoteFontOrStylesheet(endpoint, stylesheetSource: true), isTrue);
  });

  test('remote font endpoints remain forbidden in ordinary documentation', () {
    for (final Uri uri in <Uri>[
      Uri.https('fonts.googleapis.com', '/css2'),
      Uri.https('fonts.gstatic.com', '/font.woff2'),
    ]) {
      expect(_isRemoteFontOrStylesheet(uri, documentation: true), isTrue);
    }
  });

  test('ShadCN names committed product font assets', () {
    const ShadcnStylesheet stylesheet = ShadcnStylesheet();
    expect(stylesheet.fonts.sans, "'Akzidenz-GroteskPro'");
    expect(stylesheet.fonts.heading, "'ITCAvantGardeStd'");
    expect(stylesheet.fonts.mono, "'Hack'");
  });

  test('Neubrutalism font stacks use embedded faces in both variants', () {
    for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
      final NeubrutalismStylesheet stylesheet = NeubrutalismStylesheet(
        variant: variant,
      );
      expect(stylesheet.fonts.sans, "'Inter', Arial, Helvetica, sans-serif");
      expect(
        stylesheet.fonts.heading,
        variant == NeubrutalismVariant.neuComic
            ? "'Inter', Arial, Helvetica, sans-serif"
            : "'Space Grotesk', Arial, Helvetica, sans-serif",
      );
      expect(
        stylesheet.fonts.mono,
        "'Space Mono', 'SFMono-Regular', Consolas, monospace",
      );
      final Set<String> embeddedFamilies = RegExp(r"font-family:\s*'([^']+)'")
          .allMatches(stylesheet.fontFaces)
          .map((RegExpMatch match) => match.group(1)!)
          .toSet();
      expect(
        embeddedFamilies,
        containsAll(<String>[
          'Inter',
          'Space Grotesk',
          'Space Mono',
          'Syne',
          'Bangers',
          'Comic Neue',
        ]),
      );
      final List<RegExpMatch> sources = RegExp(
        r'''url\(['"]?([^'"\)]+)['"]?\)''',
      ).allMatches(stylesheet.fontFaces).toList();
      expect(sources, isNotEmpty);
      for (final RegExpMatch source in sources) {
        expect(
          source.group(1)!.startsWith('data:font/woff2;base64,'),
          isTrue,
          reason: 'Bundled font faces must not require remote or host assets',
        );
      }
    }
  });

  test('remote stylesheet hook is absent from core source', () {
    final String stylesheetSource = File(
      'lib/stylesheets/stylesheet.dart',
    ).readAsStringSync();
    final String appSource = File(
      'lib/component/support/app.dart',
    ).readAsStringSync();
    expect(stylesheetSource, isNot(contains('externalCssUrls')));
    expect(appSource, isNot(contains('externalCssUrls')));
    expect(appSource, isNot(contains('HeadElementData.link')));
  });

  test('docs content renderer is pinned to committed Arcane fonts', () {
    final File docsStylesheet = File(
      'arcane_jaspr_docs/arcane_jaspr_docs_web/web/styles.css',
    );
    final String docsCss = docsStylesheet.readAsStringSync();

    expect(docsCss, contains('--content-font: var(--font-sans)'));
    expect(docsCss, contains('--content-code-font: var(--font-mono)'));
    expect(docsCss, isNot(contains('--font-sans: var(--arcane-font-sans')));
    expect(docsCss, isNot(contains('--font-mono: var(--arcane-font-mono')));
    expect(
      docsCss,
      contains('body {\n  font-family: var(--font-sans) !important;'),
    );
    expect(
      docsCss,
      contains('samp {\n  font-family: var(--font-mono) !important;'),
    );
    expect(docsCss, isNot(contains("'Fira Code'")));

    final List<String> missingAssets = <String>[];
    for (final RegExpMatch match in RegExp(
      r'''url\(['"]?([^'"\)]+)['"]?\)''',
    ).allMatches(docsCss)) {
      final String url = match.group(1)!;
      if (url.startsWith('data:') || url.contains('://')) continue;
      final File asset = File('${docsStylesheet.parent.path}/$url');
      if (!asset.existsSync()) missingAssets.add(asset.path);
    }
    expect(missingAssets, isEmpty, reason: missingAssets.join('\n'));
  });
}
