import 'dart:async';
import 'dart:math';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/slot_counter_props.dart';

/// ShadCN Slot Counter renderer (stateful with animation).
class ShadcnSlotCounter extends StatefulComponent {
  final SlotCounterProps props;

  const ShadcnSlotCounter(this.props, {super.key});

  @override
  State<ShadcnSlotCounter> createState() => _ShadcnSlotCounterState();
}

class _ShadcnSlotCounterState extends State<ShadcnSlotCounter> {
  final Random _random = Random();
  int _currentValue = 0;
  int _targetValue = 0;
  bool _isSpinning = false;
  Timer? _spinTimer;
  Timer? _pauseTimer;
  int _spinCount = 0;

  @override
  void initState() {
    super.initState();
    if (component.props.fixedValue != null) {
      _currentValue = component.props.fixedValue!;
      _targetValue = component.props.fixedValue!;
    } else {
      _currentValue = _generateRandomValue();
      _targetValue = _currentValue;
      if (component.props.autoStart) {
        _scheduleNextSpin();
      }
    }
  }

  @override
  void dispose() {
    _spinTimer?.cancel();
    _pauseTimer?.cancel();
    super.dispose();
  }

  int _generateRandomValue() {
    return component.props.minValue +
        _random.nextInt(
          component.props.maxValue - component.props.minValue + 1,
        );
  }

  void _scheduleNextSpin() {
    if (component.props.fixedValue != null) return;

    final pauseMs =
        (component.props.basePauseSeconds * 1000) +
        (_random.nextInt(component.props.randomPauseSeconds + 1) * 1000);

    _pauseTimer = Timer(Duration(milliseconds: pauseMs), () {
      _startSpinning();
    });
  }

  void _startSpinning() {
    _targetValue = _generateRandomValue();
    _spinCount = 0;
    final totalSpinUpdates =
        component.props.spinDurationMs ~/ component.props.spinIntervalMs;

    setState(() {
      _isSpinning = true;
    });

    _spinTimer = Timer.periodic(
      Duration(milliseconds: component.props.spinIntervalMs),
      (timer) {
        _spinCount++;

        if (_spinCount >= totalSpinUpdates) {
          timer.cancel();
          setState(() {
            _currentValue = _targetValue;
            _isSpinning = false;
          });
          component.props.onValueChange?.call(_currentValue);
          _scheduleNextSpin();
        } else {
          final progress = _spinCount / totalSpinUpdates;

          if (progress > 0.8) {
            final diff = (_targetValue - _currentValue).abs();
            final maxDelta = (diff * (1 - progress) * 2).toInt().clamp(1, 500);
            final newValue =
                _targetValue + _random.nextInt(maxDelta * 2 + 1) - maxDelta;
            setState(() {
              _currentValue = newValue.clamp(
                component.props.minValue,
                component.props.maxValue,
              );
            });
          } else {
            setState(() {
              _currentValue = _generateRandomValue();
            });
          }
        }
      },
    );
  }

  String _formatValue(int value) {
    if (component.props.minDigits != null) {
      return value.toString().padLeft(component.props.minDigits!, '0');
    }
    return value.toString();
  }

  String _getFontSize(SlotCounterSize size) {
    switch (size) {
      case SlotCounterSize.xs:
        return '0.75rem';
      case SlotCounterSize.sm:
        return '0.875rem';
      case SlotCounterSize.md:
        return '1rem';
      case SlotCounterSize.lg:
        return '1.25rem';
      case SlotCounterSize.xl:
        return '1.5rem';
    }
  }

  String _getColor(SlotCounterColor color) {
    switch (color) {
      case SlotCounterColor.primary:
        return 'var(--foreground)';
      case SlotCounterColor.accent:
        return 'var(--primary)';
      case SlotCounterColor.muted:
        return 'var(--muted-foreground)';
      case SlotCounterColor.success:
        return 'var(--success)';
      case SlotCounterColor.warning:
        return 'var(--warning)';
      case SlotCounterColor.destructive:
        return 'var(--destructive)';
    }
  }

  @override
  Component build(BuildContext context) {
    final displayValue = _formatValue(_currentValue);

    return dom.div(
      classes: 'arcane-slot-counter',
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'flex-direction': 'column',
          'align-items': 'center',
          'gap': 'var(--space-1)',
          ...?component.props.decoration?.universalStyles(),
          ...?component.props.styles?.toMap(),
        },
      ),
      [
        // Value row
        dom.div(
          styles: dom.Styles(
            raw: {
              'display': 'inline-flex',
              'align-items': 'baseline',
              'gap': 'var(--space-1)',
              if (component.props.monospace)
                'font-family':
                    'ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace',
            },
          ),
          [
            // Prefix
            if (component.props.prefix != null)
              dom.span(
                styles: dom.Styles(
                  raw: {
                    'font-size': _getFontSize(component.props.affixSize),
                    'color': _getColor(component.props.affixColor),
                  },
                ),
                [Component.text(component.props.prefix!)],
              ),
            // Value
            dom.span(
              styles: dom.Styles(
                raw: {
                  'font-size': _getFontSize(component.props.valueSize),
                  'font-weight': component.props.valueBold ? '700' : '400',
                  'color': _getColor(component.props.valueColor),
                  'opacity': _isSpinning ? '0.7' : '1',
                  'transition': 'all var(--transition)',
                },
              ),
              [Component.text(displayValue)],
            ),
            // Suffix
            if (component.props.suffix != null)
              dom.span(
                styles: dom.Styles(
                  raw: {
                    'font-size': _getFontSize(component.props.affixSize),
                    'color': _getColor(component.props.affixColor),
                  },
                ),
                [Component.text(component.props.suffix!)],
              ),
          ],
        ),
        // Label
        if (component.props.label != null)
          dom.div(
            styles: dom.Styles(
              raw: {
                'font-size': _getFontSize(component.props.labelSize),
                'color': _getColor(component.props.labelColor),
                'text-transform': 'uppercase',
                'letter-spacing': '0.05em',
              },
            ),
            [Component.text(component.props.label!)],
          ),
      ],
    );
  }
}

/// ShadCN Slot Counter Row renderer.
class ShadcnSlotCounterRow extends StatelessComponent {
  final SlotCounterRowProps props;

  const ShadcnSlotCounterRow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-slot-counter-row',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'flex-start',
          'justify-content': props.justifyContent,
          'gap': props.gap,
          if (props.wrap) 'flex-wrap': 'wrap',
        },
      ),
      [for (final counter in props.counters) ShadcnSlotCounter(counter)],
    );
  }
}

/// ShadCN Slot Counter Card renderer.
class ShadcnSlotCounterCard extends StatelessComponent {
  final SlotCounterCardProps props;

  const ShadcnSlotCounterCard(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-slot-counter-card',
      attributes: const <String, String>{
        'data-arcane-surface': 'slot-counter-card',
      },
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'flex-direction': 'column',
          'align-items': 'center',
          'padding': props.padding,
          'border-radius': 'var(--radius-sm)',
          if (props.showBackground) 'background-color': 'var(--card)',
          if (props.showBorder) 'border': '1px solid var(--border)',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      [ShadcnSlotCounter(props.counter)],
    );
  }
}
