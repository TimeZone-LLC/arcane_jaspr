import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/dom.dart' as dom;

import '../../core/interaction/runtime/runtime.dart';
import 'scripts/slider_scripts.dart';
import 'scripts/input/input_scripts.dart';
import 'scripts/button/button_scripts.dart';
import 'scripts/navigation/navigation_scripts.dart';
import 'scripts/dialog/dialog_scripts.dart';
import 'scripts/view/view_scripts.dart';
import 'scripts/theme/rainbow_scripts.dart';
import 'scripts/carousel/carousel_scripts.dart';
import 'scripts/gallery/gallery_drag_scripts.dart';
import 'scripts/gallery/gallery_scripts.dart';

class ArcaneScripts {
  ArcaneScripts._();

  static String get runtime => arcaneInteractivityRuntimeJs;

  static String get runtimeCss => arcaneInteractivityRuntimeCss;

  static String get legacy =>
      '''
(function() {
  'use strict';

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', bindAllComponents);
  } else {
    setTimeout(bindAllComponents, 100);
  }

  function bindAllComponents() {
    bindSliders();
    bindColorInputs();
    bindCheckboxes();
    bindToggleSwitches();
    bindRadioButtons();
    bindNumberInputs();
    bindFileUploads();
    bindMutableText();
    bindOtpInputs();
    bindComboboxes();
    bindCalendars();
    bindDatePickers();
    bindTimePickers();
    bindFormattedInputs();
    bindToggleButtonGroups();
    bindCycleButtons();
    bindToggleButtons();
    bindButtons();
    bindCopyButtons();
    bindExpandersAccordions();
    bindSelectors();
    bindTreeViews();
    bindPagination();
    bindBackToTop();
    bindContextMenus();
    bindMenubars();
    bindResizables();
    bindCommandPalettes();
    bindSteps();
    bindTimelines();
    bindDotIndicators();
    bindTrackers();
    bindDocsToc();
    bindPopovers();
    bindTooltips();
    bindDialogs();
    bindDrawers();
    bindMobileMenus();
    bindSheets();
    bindEmailDialogs();
    bindTimeDialogs();
    bindItemPickers();
    bindChatScreens();
    bindMapDebugMode();
    bindMapPinTooltips();
    bindLocationListHover();
    bindRainbowTheme();
    bindCarousels();
  }

  ${SliderScripts.code}
  ${InputScripts.code}
  ${ButtonScripts.code}
  ${NavigationScripts.code}
  ${DialogScripts.code}
  ${ViewScripts.code}
  ${RainbowScripts.code}
  ${CarouselScripts.code}
  ${GalleryScripts.code}
  ${GalleryDragScripts.code}
})();
''';

  static String get all => '$runtime\n$legacy';
}

class ArcaneScriptsComponent extends StatelessWidget {
  const ArcaneScriptsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return dom.script(content: ArcaneScripts.all);
  }
}
