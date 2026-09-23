import 'package:arcane_jaspr/core/rendering/base/select_render_base.dart';

/// Neon Select renderer (neutralized skeleton).
class NeonSelect<T> extends SelectRenderBase<T> {
  const NeonSelect(super.props, {super.key});

  @override
  String get classPrefix => 'neon';

  @override
  String get surfaceIdPrefix => 'neon-select-';

  @override
  String get requiredAsteriskColor => 'var(--foreground)';

  @override
  String get controlBorderColor => 'var(--neon-control-border)';

  @override
  Map<String, String> triggerStyles(
    String height,
    String padding,
    String fontSize,
    String triggerColor,
    String borderColor,
  ) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'justify-content': 'space-between',
    'gap': '0.625rem',
    'box-sizing': 'border-box',
    'width': '100%',
    'min-width': '0',
    'height': height,
    'padding': padding,
    'background': 'var(--input)',
    'border': '1px solid $borderColor',
    'border-radius': 'var(--radius-md)',
    'color': triggerColor,
    'font': 'inherit',
    'font-size': fontSize,
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    'outline': 'none',
    'box-shadow': 'none',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> dropdownStyles(String maxHeight) => <String, String>{
    'position': 'absolute',
    'z-index': '1060',
    'top': 'calc(100% + 8px)',
    'left': '0',
    'box-sizing': 'border-box',
    'width': '100%',
    'min-width': '100%',
    'max-width': 'calc(100vw - 8px)',
    'max-height': maxHeight,
    'overflow-y': 'auto',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
  };

  @override
  Map<String, String> get searchWrapperStyles => const <String, String>{
    'box-sizing': 'border-box',
    'width': '100%',
    'padding': '0.35rem',
  };

  @override
  Map<String, String> get searchInputStyles => const <String, String>{
    'box-sizing': 'border-box',
    'width': '100%',
    'height': '2.5rem',
    'padding': '0.5rem 0.75rem',
    'border': '1px solid var(--neon-control-border)',
    'border-radius': 'var(--radius-sm)',
    'outline': 'none',
    'background': 'var(--input)',
    'box-shadow': 'none',
    'color': 'var(--foreground)',
    'font': 'inherit',
  };

  @override
  Map<String, String> optionStyles(
    bool isSelected,
    bool isDisabled,
  ) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
    'box-sizing': 'border-box',
    'width': '100%',
    'border': '0',
    'background': isSelected ? 'rgba(var(--primary-rgb), 0.14)' : 'transparent',
    'color': isSelected ? 'var(--neon-accent-ink)' : 'var(--foreground)',
    'font': 'inherit',
    'text-align': 'left',
    'cursor': isDisabled ? 'not-allowed' : 'pointer',
    if (isDisabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> optionCheckboxStyles(bool isSelected) =>
      const <String, String>{};

  @override
  String get optionCheckColor => 'var(--foreground)';

  @override
  String optionIconColor(bool isSelected) => 'var(--foreground)';
}
