const Map<String, String> shadcnFieldLabelStyles = <String, String>{
  'font-size': '0.875rem',
  'font-weight': '500',
  'line-height': '1.25rem',
  'color': 'var(--foreground)',
};

/// v4 control heights (`h-8`, `h-9`, `h-10`) read through tokens, so a page
/// can raise every control together: a touch layout sets
/// `--shadcn-control-h-sm`, `--shadcn-control-h` and `--shadcn-control-h-lg`
/// to 44px.
const String shadcnControlHeightSm = 'var(--shadcn-control-h-sm, 2rem)';
const String shadcnControlHeightMd = 'var(--shadcn-control-h, 2.25rem)';
const String shadcnControlHeightLg = 'var(--shadcn-control-h-lg, 2.5rem)';
