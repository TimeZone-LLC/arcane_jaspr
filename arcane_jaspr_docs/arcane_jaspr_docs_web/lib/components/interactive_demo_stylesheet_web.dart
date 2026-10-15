import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:web/web.dart' as web;

ArcaneStylesheet _resolvePaletteStylesheet(
  String stylesheetId,
  web.Element? root,
  Map<String, ArcaneStylesheet> stylesheets,
  ArcaneStylesheet fallbackStylesheet,
) {
  String? storedPaletteId = web.window.localStorage.getItem(
    'arcane-palette-id-$stylesheetId',
  );
  ArcaneStylesheet? storedStylesheet = stylesheets[storedPaletteId];
  if (storedStylesheet != null) return storedStylesheet;

  if (root != null) {
    for (String paletteId in stylesheets.keys) {
      if (root.classList.contains('kb-palette-$paletteId') ||
          root.classList.contains('$stylesheetId-$paletteId')) {
        return stylesheets[paletteId] ?? fallbackStylesheet;
      }
    }
  }

  return stylesheets.values.isEmpty
      ? fallbackStylesheet
      : stylesheets.values.first;
}

ArcaneStylesheet resolveDemoStylesheet(
  ArcaneStylesheet? parentStylesheet, {
  required Map<String, ArcaneStylesheet> shadcnStylesheets,
  required Map<String, ArcaneStylesheet> neonStylesheets,
  required Map<String, ArcaneStylesheet> neubrutalismStylesheets,
  required Map<String, ArcaneStylesheet> win95Stylesheets,
  required ArcaneStylesheet asciiStylesheet,
  required ArcaneStylesheet fallbackStylesheet,
}) {
  web.Element? root = web.document.getElementById('arcane-root');
  String? storedStylesheetId = web.window.localStorage.getItem(
    'arcane-stylesheet-id',
  );
  if (storedStylesheetId == 'ascii') {
    return asciiStylesheet;
  }
  if (storedStylesheetId == 'shadcn') {
    return _resolvePaletteStylesheet(
      'shadcn',
      root,
      shadcnStylesheets,
      fallbackStylesheet,
    );
  }
  if (storedStylesheetId == 'neon') {
    return _resolvePaletteStylesheet(
      'neon',
      root,
      neonStylesheets,
      fallbackStylesheet,
    );
  }
  if (storedStylesheetId == 'neubrutalism') {
    return _resolvePaletteStylesheet(
      'neubrutalism',
      root,
      neubrutalismStylesheets,
      fallbackStylesheet,
    );
  }
  if (storedStylesheetId == 'win95') {
    return _resolvePaletteStylesheet(
      'win95',
      root,
      win95Stylesheets,
      fallbackStylesheet,
    );
  }

  if (root != null) {
    if (root.classList.contains('kb-style-ascii')) {
      return asciiStylesheet;
    }
    if (root.classList.contains('kb-style-shadcn')) {
      return _resolvePaletteStylesheet(
        'shadcn',
        root,
        shadcnStylesheets,
        fallbackStylesheet,
      );
    }
    if (root.classList.contains('kb-style-neon')) {
      return _resolvePaletteStylesheet(
        'neon',
        root,
        neonStylesheets,
        fallbackStylesheet,
      );
    }
    if (root.classList.contains('kb-style-neubrutalism')) {
      return _resolvePaletteStylesheet(
        'neubrutalism',
        root,
        neubrutalismStylesheets,
        fallbackStylesheet,
      );
    }
    if (root.classList.contains('kb-style-win95') ||
        root.className.split(' ').any((String c) => c.startsWith('win95-'))) {
      return _resolvePaletteStylesheet(
        'win95',
        root,
        win95Stylesheets,
        fallbackStylesheet,
      );
    }
  }

  return parentStylesheet ?? fallbackStylesheet;
}

Brightness resolveDemoBrightness(Brightness fallbackBrightness) {
  String? storedMode = web.window.localStorage.getItem('arcane-theme-mode');
  if (storedMode == 'light') return Brightness.light;
  if (storedMode == 'dark') return Brightness.dark;

  web.Element? root = web.document.getElementById('arcane-root');
  if (root != null) {
    if (root.classList.contains('light')) return Brightness.light;
    if (root.classList.contains('dark')) return Brightness.dark;
  }

  if (web.document.documentElement?.classList.contains('light') ?? false) {
    return Brightness.light;
  }
  if (web.document.documentElement?.classList.contains('dark') ?? false) {
    return Brightness.dark;
  }

  return fallbackBrightness;
}
