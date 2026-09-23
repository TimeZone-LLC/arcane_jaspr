import 'package:arcane_jaspr/core/props/toggle_group_props.dart';
import 'package:arcane_jaspr/core/rendering/base/toggle_group_render_base.dart';

/// ShadCN-style toggle group component.
/// Reference: https://ui.shadcn.com/docs/components/toggle-group
///
/// Items follow the v4 Toggle recipe (`h-9 px-2 min-w-9 rounded-md text-sm
/// font-medium`, outline adds `border-input shadow-xs`). Hover and the "on"
/// fill come from the theme CSS through the `--shadcn-item-*` variables, keyed
/// on the runtime-maintained `data-arcane-state`.
class ShadcnToggleGroup extends ToggleGroupRenderBase {
  const ShadcnToggleGroup(super.props, {super.key});

  @override
  String get cssClass => 'arcane-toggle-group';

  @override
  String get itemBaseClass => 'arcane-toggle-group-item';

  @override
  Map<String, String> get containerStyles => const <String, String>{
    'display': 'inline-flex',
    'align-items': 'center',
    'justify-content': 'center',
    'border-radius': 'var(--radius-md)',
    'background-color': 'transparent',
    'gap': '0.25rem',
  };

  @override
  Map<String, String> extraRootAttrs() => <String, String>{
    'data-variant': _variant,
  };

  @override
  Map<String, String> extraItemAttrs(bool isSelected, bool isDisabled) =>
      <String, String>{'data-variant': _variant};

  String get _variant => switch (props.variant) {
    ToggleGroupVariantStyle.defaultVariant => 'default',
    ToggleGroupVariantStyle.outline => 'outline',
  };

  @override
  Map<String, String> itemStyles(bool isSelected, bool isDisabled) {
    final (String height, String paddingX) = switch (props.size) {
      ToggleGroupSizeVariant.sm => ('2rem', '0.375rem'),
      ToggleGroupSizeVariant.md => ('2.25rem', '0.5rem'),
      ToggleGroupSizeVariant.lg => ('2.5rem', '0.625rem'),
    };
    final bool outline = props.variant == ToggleGroupVariantStyle.outline;

    return <String, String>{
      'display': 'inline-flex',
      'align-items': 'center',
      'justify-content': 'center',
      'gap': '0.5rem',
      'height': height,
      'padding': '0 $paddingX',
      'min-width': height,
      'box-sizing': 'border-box',
      'border-radius': 'var(--radius-md)',
      'border': outline
          ? '1px solid var(--shadcn-control-border-color, var(--input))'
          : '1px solid var(--shadcn-control-border-color, transparent)',
      'box-shadow': outline
          ? 'var(--shadcn-control-shadow, var(--shadow-xs))'
          : 'var(--shadcn-control-shadow, none)',
      'font-size': '0.875rem',
      'font-weight': '500',
      'white-space': 'nowrap',
      'background-color': 'var(--shadcn-item-background, transparent)',
      'color': 'var(--shadcn-item-foreground, inherit)',
      'outline': 'none',
      'transition':
          'color var(--transition), background-color var(--transition), '
          'border-color var(--transition), box-shadow var(--transition)',
      'cursor': isDisabled ? 'not-allowed' : 'pointer',
      'pointer-events': isDisabled ? 'none' : 'auto',
      'opacity': isDisabled ? '0.5' : '1',
    };
  }
}
