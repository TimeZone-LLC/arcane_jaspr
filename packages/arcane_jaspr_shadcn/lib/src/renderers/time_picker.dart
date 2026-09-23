import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/time_picker_props.dart';
import 'package:arcane_jaspr/core/rendering/base/time_picker_render_base.dart';

/// ShadCN Time Picker renderer.
class ShadcnTimePicker extends TimePickerRenderBase {
  const ShadcnTimePicker(super.props, {super.key});

  @override
  Map<String, String> get sizeStyles => switch (props.size) {
    ComponentSize.sm => const <String, String>{
      'height': '32px',
      'fontSize': '0.875rem',
    },
    ComponentSize.md => const <String, String>{
      'height': '36px',
      'fontSize': '0.875rem',
    },
    ComponentSize.lg => const <String, String>{
      'height': '40px',
      'fontSize': '1rem',
    },
  };

  @override
  String rootClasses(bool hasError) =>
      'arcane-time-picker ${props.isOpen ? 'open' : ''} ${props.disabled ? 'disabled' : ''} ${hasError ? 'error' : ''}';

  @override
  Map<String, String> get rootAttributes => const <String, String>{};

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'position': 'relative',
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-1)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--foreground)',
  };

  @override
  String get triggerClasses =>
      'arcane-time-picker-trigger ${props.disabled ? 'disabled' : ''}';

  @override
  Map<String, String> get triggerAttributes => <String, String>{
    'aria-haspopup': 'dialog',
    'aria-expanded': '${props.isOpen}',
    if (props.disabled) 'disabled': 'true',
  };

  @override
  Map<String, String> triggerStyles({
    required String height,
    required String fontSize,
    required bool hasError,
    required bool hasValue,
  }) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': 'var(--space-2)',
    'width': '100%',
    'height': height,
    'padding': '0 0.75rem',
    'background': 'var(--shadcn-item-background, var(--background))',
    'border':
        '1px solid var(--shadcn-control-border-color, ${hasError ? 'var(--destructive)' : 'var(--input)'})',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'font-size': fontSize,
    'color':
        'var(--shadcn-item-foreground, ${hasValue ? 'var(--foreground)' : 'var(--muted-foreground)'})',
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    'transition':
        'background-color var(--transition), color var(--transition), '
        'border-color var(--transition), box-shadow var(--transition)',
    'text-align': 'left',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> get iconStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
  };

  @override
  String get clearClasses => 'arcane-time-picker-clear';

  @override
  Map<String, String> get clearStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
    'cursor': 'pointer',
    'transition': 'color var(--transition)',
  };

  @override
  String get dropdownClasses => 'arcane-time-picker-dropdown';

  @override
  Map<String, String> get dropdownStyles => const <String, String>{
    'position': 'absolute',
    'top': '100%',
    'left': '0',
    'margin-top': '0.25rem',
    'z-index': '50',
    'background': 'var(--popover)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
    'padding': '1rem',
    'min-width': '280px',
  };

  @override
  Map<String, String> get columnsRowStyles => const <String, String>{
    'display': 'flex',
    'gap': 'var(--space-4)',
  };

  @override
  Map<String, String> get columnStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-1)',
  };

  @override
  Map<String, String> get columnLabelStyles => const <String, String>{
    'font-size': 'var(--font-size-xs)',
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--muted-foreground)',
    'text-transform': 'uppercase',
    'margin-bottom': '0.25rem',
  };

  @override
  Map<String, String> get columnScrollStyles => const <String, String>{
    'max-height': '200px',
    'overflow-y': 'auto',
    'display': 'flex',
    'flex-direction': 'column',
    'gap': '2px',
  };

  @override
  String get optionClass => 'arcane-time-picker-option';

  @override
  Map<String, String> optionButtonStyles({required bool selected}) =>
      <String, String>{
        'padding': '0.25rem 1rem',
        'border': 'none',
        'border-radius': 'var(--radius-sm)',
        'background': selected
            ? 'var(--primary)'
            : 'var(--shadcn-item-background, transparent)',
        'color': selected
            ? 'var(--primary-foreground)'
            : 'var(--shadcn-item-foreground, var(--foreground))',
        'cursor': 'pointer',
        'font-size': 'var(--font-size-sm)',
        'text-align': 'center',
        'min-width': '48px',
        'transition': 'all var(--transition)',
      };

  @override
  Map<String, String> amPmButtonStyles({required bool selected}) =>
      <String, String>{
        'padding': '0.5rem 1rem',
        'border': 'none',
        'border-radius': 'var(--radius-sm)',
        'background': selected
            ? 'var(--primary)'
            : 'var(--shadcn-item-background, transparent)',
        'color': selected
            ? 'var(--primary-foreground)'
            : 'var(--shadcn-item-foreground, var(--foreground))',
        'cursor': 'pointer',
        'font-size': 'var(--font-size-sm)',
        'transition': 'all var(--transition)',
      };

  @override
  Map<String, String> get actionsRowStyles => const <String, String>{
    'display': 'flex',
    'justify-content': 'flex-end',
    'gap': 'var(--space-2)',
    'margin-top': '1rem',
    'padding-top': '1rem',
    'border-top': '1px solid var(--border)',
  };

  @override
  Component buildActionButton({
    required bool primary,
    required void Function()? onClick,
    required String label,
  }) {
    return dom.button(
      type: dom.ButtonType.button,
      styles: dom.Styles(
        raw: primary
            ? const <String, String>{
                'padding': '0.5rem 1rem',
                'border': 'none',
                'border-radius': 'var(--radius-md)',
                'background': 'var(--primary)',
                'color': 'var(--primary-foreground)',
                'cursor': 'pointer',
                'font-size': 'var(--font-size-sm)',
              }
            : const <String, String>{
                'padding': '0.5rem 1rem',
                'border': '1px solid var(--border)',
                'border-radius': 'var(--radius-md)',
                'background': 'transparent',
                'color': 'var(--foreground)',
                'cursor': 'pointer',
                'font-size': 'var(--font-size-sm)',
              },
      ),
      events: <String, EventCallback>{'click': (_) => onClick?.call()},
      <Component>[Component.text(label)],
    );
  }
}
