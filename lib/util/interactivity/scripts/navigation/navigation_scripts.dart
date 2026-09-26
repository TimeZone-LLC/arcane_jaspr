library;

import 'accordion_scripts.dart';
import 'back_to_top_scripts.dart';
import 'command_palette_scripts.dart';
import 'context_menu_scripts.dart';
import 'dot_indicator_scripts.dart';
import 'menubar_scripts.dart';
import 'pagination_scripts.dart';
import 'resizable_scripts.dart';
import 'selector_scripts.dart';
import 'steps_scripts.dart';
import 'timeline_scripts.dart';
import 'toc_scripts.dart';
import 'tracker_scripts.dart';
import 'tree_view_scripts.dart';

export 'accordion_scripts.dart';
export 'back_to_top_scripts.dart';
export 'command_palette_scripts.dart';
export 'context_menu_scripts.dart';
export 'dot_indicator_scripts.dart';
export 'menubar_scripts.dart';
export 'pagination_scripts.dart';
export 'resizable_scripts.dart';
export 'selector_scripts.dart';
export 'steps_scripts.dart';
export 'timeline_scripts.dart';
export 'toc_scripts.dart';
export 'tracker_scripts.dart';
export 'tree_view_scripts.dart';

/// Combined navigation scripts.
class NavigationScripts {
  NavigationScripts._();

  static String get code =>
      '''
${AccordionScripts.code}
${SelectorScripts.code}
${TreeViewScripts.code}
${PaginationScripts.code}
${BackToTopScripts.code}
${ContextMenuScripts.code}
${MenubarScripts.code}
${ResizableScripts.code}
${CommandPaletteScripts.code}
${StepsScripts.code}
${TimelineScripts.code}
${DotIndicatorScripts.code}
${TrackerScripts.code}
${TocScripts.code}
''';
}
