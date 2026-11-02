import 'dart:async';
import 'dart:math';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/slot_counter_props.dart';
import 'package:arcane_jaspr_neubrutalism/src/motion/neubrutalism_motion_stub.dart'
    if (dart.library.js_interop) 'package:arcane_jaspr_neubrutalism/src/motion/neubrutalism_motion_web.dart';

/// Neubrutalism Slot Counter renderer (stateful with animation).
class NeubrutalismSlotCounter extends StatefulComponent {
  final SlotCounterProps props;

  const NeubrutalismSlotCounter(this.props, {super.key});

  @override
  State<NeubrutalismSlotCounter> createState() =>
      _NeubrutalismSlotCounterState();
}

class _NeubrutalismSlotCounterState extends State<NeubrutalismSlotCounter> {
  final Random _random = Random();
  int _currentValue = 0;
  int _targetValue = 0;
  bool _isSpinning = false;
  Timer? _spinTimer;
  Timer? _pauseTimer;
  int _spinCount = 0;
  late final NeubrutalismMotionObserver _motion;

  @override
  void initState() {
    super.initState();
    _motion = NeubrutalismMotionObserver(_onMotionChanged);
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
  void didUpdateComponent(NeubrutalismSlotCounter oldComponent) {
    super.didUpdateComponent(oldComponent);
    final SlotCounterProps previous = oldComponent.props;
    final SlotCounterProps next = component.props;
    if (previous.fixedValue == next.fixedValue &&
        previous.autoStart == next.autoStart &&
        previous.minValue == next.minValue &&
        previous.maxValue == next.maxValue &&
        previous.basePauseSeconds == next.basePauseSeconds &&
        previous.randomPauseSeconds == next.randomPauseSeconds &&
        previous.spinDurationMs == next.spinDurationMs &&
        previous.spinIntervalMs == next.spinIntervalMs) {
      return;
    }
    _cancelTimers();
    _currentValue =
        next.fixedValue ?? _targetValue.clamp(next.minValue, next.maxValue);
    _targetValue = _currentValue;
    _isSpinning = false;
    _scheduleNextSpin();
  }

  @override
  void dispose() {
    _cancelTimers();
    _motion.dispose();
    super.dispose();
  }

  void _cancelTimers() {
    _spinTimer?.cancel();
    _pauseTimer?.cancel();
    _spinTimer = null;
    _pauseTimer = null;
  }

  void _onMotionChanged(bool allowed) {
    _cancelTimers();
    if (!allowed) {
      if (_isSpinning && mounted) {
        setState(() {
          _currentValue = _targetValue;
          _isSpinning = false;
        });
        component.props.onValueChange?.call(_currentValue);
      }
      return;
    }
    _scheduleNextSpin();
  }

  int _generateRandomValue() {
    return component.props.minValue +
        _random.nextInt(
          component.props.maxValue - component.props.minValue + 1,
        );
  }

  void _scheduleNextSpin() {
    if (!mounted ||
        component.props.fixedValue != null ||
        !component.props.autoStart ||
        !_motion.canAnimate) {
      return;
    }

    final int pauseMs =
        (component.props.basePauseSeconds * 1000) +
        (_random.nextInt(component.props.randomPauseSeconds + 1) * 1000);

    _pauseTimer = Timer(Duration(milliseconds: pauseMs), () {
      _startSpinning();
    });
  }

  void _startSpinning() {
    if (!mounted || !_motion.canAnimate) return;
    _targetValue = _generateRandomValue();
    _spinCount = 0;
    final int totalSpinUpdates =
        component.props.spinDurationMs ~/ component.props.spinIntervalMs;

    setState(() {
      _isSpinning = true;
    });

    _spinTimer = Timer.periodic(
      Duration(milliseconds: component.props.spinIntervalMs),
      (Timer timer) {
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
          final double progress = _spinCount / totalSpinUpdates;

          if (progress > 0.8) {
            final int diff = (_targetValue - _currentValue).abs();
            final int maxDelta = (diff * (1 - progress) * 2).toInt().clamp(
              1,
              500,
            );
            final int newValue =
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
        return '1.375rem';
      case SlotCounterSize.xl:
        return '1.625rem';
    }
  }

  String _getColor(SlotCounterColor color) {
    switch (color) {
      case SlotCounterColor.primary:
        return 'var(--foreground)';
      case SlotCounterColor.accent:
        return 'var(--foreground)';
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
    final String displayValue = _formatValue(_currentValue);

    return dom.div(
      classes: 'neubrutalism-slot-counter',
      attributes: <String, String>{
        'data-fixed': '${component.props.fixedValue != null}',
        'data-state': _isSpinning ? 'spinning' : 'idle',
      },
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'flex-direction': 'column',
          'align-items': 'center',
          'gap': 'var(--space-2)',
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
              'gap': 'var(--space-2)',
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
              key: ValueKey<int?>(component.props.fixedValue),
              classes: 'neubrutalism-slot-counter-value',
              styles: dom.Styles(
                raw: {
                  'font-size': _getFontSize(component.props.valueSize),
                  'font-weight': component.props.valueBold ? '700' : '400',
                  'font-variant-numeric': 'tabular-nums',
                  'color': _getColor(component.props.valueColor),
                  'opacity': _isSpinning ? '0.7' : '1',
                  'transition': 'opacity 200ms ease',
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
                'font-family': 'var(--font-sans)',
                'font-size': component.props.labelSize == SlotCounterSize.xs
                    ? '0.8125rem'
                    : _getFontSize(component.props.labelSize),
                'font-weight': '700',
                'color': _getColor(component.props.labelColor),
                'text-transform': 'uppercase',
                'letter-spacing': '0.04em',
              },
            ),
            [Component.text(component.props.label!)],
          ),
      ],
    );
  }
}

/// Neubrutalism Slot Counter Row renderer.
class NeubrutalismSlotCounterRow extends StatelessComponent {
  final SlotCounterRowProps props;

  const NeubrutalismSlotCounterRow(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-slot-counter-row',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'flex-start',
          'justify-content': props.justifyContent,
          'gap': props.gap,
          if (props.wrap) 'flex-wrap': 'wrap',
        },
      ),
      [for (final counter in props.counters) NeubrutalismSlotCounter(counter)],
    );
  }
}

/// Neubrutalism Slot Counter Card renderer.
class NeubrutalismSlotCounterCard extends StatelessComponent {
  final SlotCounterCardProps props;

  const NeubrutalismSlotCounterCard(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'neubrutalism-slot-counter-card',
      attributes: const <String, String>{
        'data-arcane-surface': 'slot-counter-card',
      },
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'flex-direction': 'column',
          'align-items': 'center',
          'padding': props.padding,
          if (props.showBackground) ...{
            'background': 'var(--nb-paper, var(--card))',
            'box-shadow':
                'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
          } else ...{
            'border-radius': 'var(--nb-radius-soft, 4px)',
          },
          if (props.showBorder)
            'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      [NeubrutalismSlotCounter(props.counter)],
    );
  }
}
