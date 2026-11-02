import 'package:arcane_jaspr/core/rendering/base/select_render_base.dart';

/// Neubrutalism Select renderer.
class NeubrutalismSelect<T> extends SelectRenderBase<T> {
  const NeubrutalismSelect(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  String get surfaceIdPrefix => 'nb-select-';

  @override
  String get requiredAsteriskColor => 'var(--nb-accent, var(--primary))';

  @override
  String get controlBorderColor => 'var(--nb-line, #000)';

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
    'width': '100%',
    'height': height,
    'padding': padding,
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid $borderColor',
    'border-radius': 'var(--nb-radius-tight, 0)',
    'font-family': 'var(--font-body)',
    'font-weight': '600',
    'font-size': fontSize,
    'color': triggerColor,
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    'outline': 'none',
    'box-shadow': 'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'transition': 'translate 0.12s ease, box-shadow 0.12s ease',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> dropdownStyles(String maxHeight) => <String, String>{
    'z-index': '50',
    'min-width': '100%',
    'max-height': maxHeight,
    'overflow-y': 'auto',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-tight, 0)',
    'box-shadow': 'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
  };

  @override
  Map<String, String> get searchWrapperStyles => const <String, String>{
    'padding': '0.625rem',
    'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
  };

  @override
  Map<String, String> get searchInputStyles => const <String, String>{
    'width': '100%',
    'padding': '0.5rem 0.75rem',
    'background': 'var(--nb-paper-soft, var(--card))',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'font-size': 'var(--font-size-sm)',
    'color': 'var(--foreground)',
    'outline': 'none',
    'transition': 'border-color 0.18s ease',
  };

  @override
  Map<String, String> optionStyles(bool isSelected, bool isDisabled) =>
      <String, String>{
        'display': 'flex',
        'align-items': 'center',
        'gap': '0.75rem',
        'width': '100%',
        'padding': '0.625rem 0.875rem',
        'background': isSelected
            ? 'var(--nb-selection-bg, var(--nb-paper-soft, var(--card)))'
            : 'transparent',
        'border': 'none',
        'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
        'font-family': 'var(--font-body)',
        'font-weight': isSelected ? '700' : '600',
        'font-size': 'var(--font-size-sm)',
        'color': 'var(--foreground)',
        'text-align': 'left',
        'cursor': isDisabled ? 'not-allowed' : 'pointer',
        'transition': 'background 0.12s ease',
        if (isDisabled) 'opacity': '0.5',
      };

  @override
  Map<String, String> optionCheckboxStyles(bool isSelected) => <String, String>{
    'width': '20px',
    'height': '20px',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'background': isSelected ? 'var(--nb-paper, var(--card))' : 'transparent',
    'display': 'flex',
    'align-items': 'center',
    'justify-content': 'center',
    'flex-shrink': '0',
    'transition': 'background 0.12s ease',
  };

  @override
  String get optionCheckColor => 'var(--foreground)';

  @override
  String optionIconColor(bool isSelected) =>
      isSelected ? 'var(--foreground)' : 'var(--muted-foreground)';
}
