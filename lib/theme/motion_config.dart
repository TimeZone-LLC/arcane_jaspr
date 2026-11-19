/// Transition timing for a theme, emitted as the `--transition*` variables.
///
/// Every control transition reads these, so a site can give library controls
/// the same duration and easing as its own hover set.
class MotionConfig {
  final String fast;
  final String base;
  final String slow;
  final String slower;

  const MotionConfig({
    this.fast = '100ms ease',
    this.base = '150ms ease',
    this.slow = '200ms ease',
    this.slower = '300ms ease',
  });
}
