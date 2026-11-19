library;

import 'checkbox_scripts.dart';
import 'calendar_scripts.dart';
import 'color_input_scripts.dart';
import 'combobox_scripts.dart';
import 'date_picker_scripts.dart';
import 'file_upload_scripts.dart';
import 'formatted_input_scripts.dart';
import 'mutable_text_scripts.dart';
import 'number_input_scripts.dart';
import 'radio_scripts.dart';
import 'time_picker_scripts.dart';
import 'toggle_switch_scripts.dart';

export 'checkbox_scripts.dart';
export 'calendar_scripts.dart';
export 'color_input_scripts.dart';
export 'combobox_scripts.dart';
export 'date_picker_scripts.dart';
export 'file_upload_scripts.dart';
export 'formatted_input_scripts.dart';
export 'mutable_text_scripts.dart';
export 'number_input_scripts.dart';
export 'radio_scripts.dart';
export 'time_picker_scripts.dart';
export 'toggle_switch_scripts.dart';

/// Combined input scripts.
class InputScripts {
  InputScripts._();

  static String get code =>
      '''
${ColorInputScripts.code}
${NumberInputScripts.code}
${CheckboxScripts.code}
${ToggleSwitchScripts.code}
${RadioScripts.code}
${MutableTextScripts.code}
${FileUploadScripts.code}
${ComboboxScripts.code}
${CalendarScripts.code}
${DatePickerScripts.code}
${TimePickerScripts.code}
${FormattedInputScripts.code}
''';
}
