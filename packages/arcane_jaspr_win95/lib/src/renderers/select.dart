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

  @override
  Map<String, String> optionCheckboxStyles(bool isSelected) =>
      const <String, String>{
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'center',
        'flex': '0 0 15px',
        'width': '15px',
        'height': '15px',
        'background': 'var(--w95-field)',
        'box-shadow': 'var(--w95-sunken)',
      };

  @override
  String get optionCheckColor => 'var(--w95-field-text)';

  @override
  String optionIconColor(bool isSelected) => 'var(--foreground)';
}
