#!/usr/bin/env dart

/// Build script for Arcane Jaspr sites.
///
/// Automatically:
/// - Generates favicon and icon sizes from web/assets/icon.png
/// - Generates manifest.json for PWA support
/// - Builds with sitemap generation
///
/// Usage:
///   dart tool/build.dart [--domain=https://example.com] [--base-url=/path]
///
/// Examples:
///   dart tool/build.dart --domain=https://timezone-llc.github.io/arcane_jaspr --base-url=/arcane_jaspr
///   dart tool/build.dart --domain=https://mysite.com
library;

import 'dart:io';

Future<void> main(List<String> args) async {
  final String? domain = _getArg(args, 'domain');
  final String? baseUrl = _getArg(args, 'base-url');

  if (domain == null) {
    print(
      'Usage: dart tool/build.dart --domain=https://example.com [--base-url=/path]',
    );
    print('');
    print('Options:');
    print('  --domain     Required. Domain for sitemap generation');
    print('  --base-url   Optional. Base URL path (e.g., /arcane_jaspr)');
    exit(1);
  }

  print('Building Arcane Jaspr site...\n');

  // Step 1: Generate icons
  await _generateIcons();

  // Step 2: Generate manifest
  await _generateManifest(baseUrl ?? '');

  // Step 3: Generate component catalog
  await _generateComponentCatalog();

  // Step 4: Generate search index
  await _generateSearchIndex(baseUrl ?? '');

  // Step 5: Build with jaspr
  await _runJasprBuild(domain, baseUrl);

  print('\nBuild complete!');
}

String? _getArg(List<String> args, String name) {
  for (final arg in args) {
    if (arg.startsWith('--$name=')) {
      return arg.substring('--$name='.length);
    }
  }
  return null;
}

Future<void> _generateIcons() async {
  final File iconFile = File('web/assets/icon.png');
  if (!iconFile.existsSync()) {
    print('No icon.png found in web/assets/ - skipping icon generation');
    return;
  }

  final File faviconFile = File('web/assets/favicon.ico');
  if (faviconFile.existsSync()) {
    final DateTime iconMod = iconFile.lastModifiedSync();
    final DateTime faviconMod = faviconFile.lastModifiedSync();
    if (faviconMod.isAfter(iconMod)) {
      print('Icons are up to date - skipping generation');
      return;
    }
  }

  print('Generating icons from web/assets/icon.png...');

  final ProcessResult result = await Process.run('python3', [
    '-c',
    '''
from PIL import Image
import os

assets_dir = "web/assets"
icon_path = os.path.join(assets_dir, "icon.png")

img = Image.open(icon_path).convert("RGBA")
w, h = img.size
print(f"  Original: {w}x{h}")

# Create square canvas with transparent background
size = max(w, h)
square = Image.new("RGBA", (size, size), (0, 0, 0, 0))
x = (size - w) // 2
y = (size - h) // 2
square.paste(img, (x, y), img)
print(f"  Padded to: {size}x{size}")

square.save(os.path.join(assets_dir, "icon-square.png"))

# Generate various sizes
sizes = [
    ("apple-touch-icon.png", 180),
    ("icon-192.png", 192),
    ("icon-512.png", 512),
    ("icon-32.png", 32),
    ("icon-16.png", 16),
]

for filename, target_size in sizes:
    resized = square.resize((target_size, target_size), Image.LANCZOS)
    resized.save(os.path.join(assets_dir, filename))
    print(f"  Generated: {filename}")

# Generate favicon.ico
ico_sizes = [(16, 16), (32, 32), (48, 48)]
ico_images = [square.resize(s, Image.LANCZOS) for s in ico_sizes]
ico_images[0].save(
    os.path.join(assets_dir, "favicon.ico"),
    format="ICO",
    sizes=ico_sizes
)
print("  Generated: favicon.ico")
''',
  ]);

  if (result.exitCode != 0) {
    print('Warning: Icon generation failed. Make sure Pillow is installed:');
    print('  pip3 install Pillow');
    print(result.stderr);
  } else {
    print(result.stdout);
  }
}

Future<void> _generateManifest(String baseUrl) async {
  final File manifestFile = File('web/manifest.json');

  // Read existing manifest or create new one
  String name = 'Arcane Jaspr';
  String shortName = 'Arcane';
  String themeColor = '#09090b';

  if (manifestFile.existsSync()) {
    // Keep existing manifest, just update paths
    print('manifest.json exists - keeping existing configuration');
    return;
  }

  print('Generating manifest.json...');

  final String manifest =
      '''{
  "name": "$name",
  "short_name": "$shortName",
  "start_url": "./",
  "display": "standalone",
  "background_color": "$themeColor",
  "theme_color": "$themeColor",
  "icons": [
    {
      "src": "assets/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "assets/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
''';

  manifestFile.writeAsStringSync(manifest);
  print('  Generated: manifest.json');
}

Future<void> _generateSearchIndex(String baseUrl) async {
  print('Generating search index...');

  final List<String> args = ['tool/generate_search_index.dart'];
  if (baseUrl.isNotEmpty) {
    args.add('--base-url=$baseUrl');
  }

  final ProcessResult result = await Process.run('dart', args);

  if (result.exitCode != 0) {
    print('Warning: Search index generation failed');
    print(result.stderr);
  } else {
    print(result.stdout);
  }
}

Future<void> _generateComponentCatalog() async {
  print('Generating component catalog...');

  final ProcessResult result = await Process.run('dart', [
    'tool/generate_component_catalog.dart',
  ]);

  if (result.exitCode != 0) {
    print('Warning: Component catalog generation failed');
    print(result.stderr);
  } else {
    print(result.stdout);
  }
}

Future<void> _runJasprBuild(String domain, String? baseUrl) async {
  print('\nRunning jaspr build...');

  final List<String> args = ['build', '--sitemap-domain=$domain'];

  if (baseUrl != null && baseUrl.isNotEmpty) {
    args.add('--dart-define=BASE_URL=$baseUrl');
  }

  print('  jaspr ${args.join(' ')}\n');

  final Process process = await Process.start(
    'jaspr',
    args,
    mode: ProcessStartMode.inheritStdio,
  );
  final int exitCode = await process.exitCode;

  if (exitCode != 0) {
    print('\nBuild failed with exit code $exitCode');
    exit(exitCode);
  }
}
