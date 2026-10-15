import 'package:arcane_jaspr/arcane_jaspr.dart';

ArcaneStylesheet resolveDemoStylesheet(
  ArcaneStylesheet? parentStylesheet, {
  required Map<String, ArcaneStylesheet> shadcnStylesheets,
  required Map<String, ArcaneStylesheet> neonStylesheets,
  required Map<String, ArcaneStylesheet> neubrutalismStylesheets,
  required Map<String, ArcaneStylesheet> win95Stylesheets,
  required ArcaneStylesheet asciiStylesheet,
  required ArcaneStylesheet fallbackStylesheet,
}) => parentStylesheet ?? fallbackStylesheet;

Brightness resolveDemoBrightness(Brightness fallbackBrightness) =>
    fallbackBrightness;
