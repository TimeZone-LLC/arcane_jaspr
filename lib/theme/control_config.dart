/// Shared geometry for form controls and buttons, emitted as `--control-*` variables.
///
/// Text inputs, search fields, selects and buttons of the same size read the
/// same height, horizontal padding, font size and label gap, so a row of mixed
/// controls lines up top and bottom.
class ControlConfig {
  final String heightSm;
  final String heightMd;
  final String heightLg;
  final String paddingX;
  final String fontSize;
  final String labelGap;

  const ControlConfig({
    this.heightSm = '32px',
    this.heightMd = '40px',
    this.heightLg = '48px',
    this.paddingX = '0.75rem',
    this.fontSize = '0.875rem',
    this.labelGap = '0.5rem',
  });
}
