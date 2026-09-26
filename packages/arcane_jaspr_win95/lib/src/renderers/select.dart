import 'package:arcane_jaspr/core/rendering/base/select_render_base.dart';

/// Sunken select fields and raised option lists.
class Win95Select<T> extends SelectRenderBase<T> {
  const Win95Select(super.props, {super.key});

  @override
  String get classPrefix => 'win95';

  @override
  String get surfaceIdPrefix => 'win95-select-';

  @override
  String get requiredAsteriskColor => 'var(--foreground)';

  @override
  String get controlBorderColor => 'var(--border)';

  @override
  Map<String, String> triggerStyles(
    String height,
    String padding,
    String fontSize,
    String triggerColor,
    String borderColor,
  ) => const <String, String>{};

  @override
  Map<String, String> dropdownStyles(String maxHeight) => <String, String>{
    'max-height': maxHeight,
    'overflow-y': 'auto',
    'overscroll-behavior': 'contain',
  };

  @override
  Map<String, String> get searchWrapperStyles => const <String, String>{};

  @override
  Map<String, String> get searchInputStyles => const <String, String>{};

  @override
  Map<String, String> optionStyles(bool isSelected, bool isDisabled) =>
      const <String, String>{};

  /// The list opens flush under the field, like a Win95 combo box.
  @override
  String get anchorOffset => '0';

  /// Rows run edge to edge inside the list's 2px window frame.
  @override
  String get optionsPadding => '0';

  /// The 13px check box well; win95_css paints the well and the shared
  /// `--w95-check` tick from the option's selection state.
  @override
  Map<String, String> optionCheckboxStyles(bool isSelected) =>
      const <String, String>{
        'position': 'relative',
        'flex': '0 0 13px',
        'width': '13px',
        'height': '13px',
      };

  @override
  String get optionCheckColor => 'var(--w95-field-text)';

  @override
  String optionIconColor(bool isSelected) => 'var(--foreground)';
}
