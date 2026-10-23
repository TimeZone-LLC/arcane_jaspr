/// Prose and documentation styles for markdown content.
///
/// This file re-exports all prose-related styles from their individual files.
/// Import this file to get all documentation styles at once.
library;

export 'prose_typography.dart';
export 'prose_code.dart';
export 'prose_callout.dart';
export 'sidebar_styles.dart';

import 'prose_typography.dart';
import 'prose_code.dart';
import 'prose_callout.dart';
import 'sidebar_styles.dart';

/// All documentation styles combined.
///
/// Use this to include all prose and documentation styles at once.
const String arcaneAllDocsStyles = '''
$arcaneProseStyles

$arcaneProseCodeStyles

$arcaneCodeCopyButtonStyles

$arcaneCalloutStyles

$arcaneSidebarTreeStyles
''';
