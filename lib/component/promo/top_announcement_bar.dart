import 'package:jaspr/dom.dart' as dom;
import 'package:arcane_jaspr/flutter.dart';

import '../../core/theme_provider.dart';

/// A thin sticky announcement bar at the top of the page.
///
/// Shows promo message with optional CTA button and dismiss functionality.
class ArcaneTopAnnouncementBar extends StatefulWidget {
  final String message;
  final String? ctaText;
  final String? ctaHref;
  final void Function()? onCtaClick;
  final void Function()? onDismiss;

  const ArcaneTopAnnouncementBar({
    required this.message,
    this.ctaText,
    this.ctaHref,
    this.onCtaClick,
    this.onDismiss,
    super.key,
  });

  @override
  State<ArcaneTopAnnouncementBar> createState() =>
      _ArcaneTopAnnouncementBarState();
}

class _ArcaneTopAnnouncementBarState extends State<ArcaneTopAnnouncementBar> {
  bool _isDismissed = false;

  void _handleDismiss() {
    setState(() => _isDismissed = true);
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const dom.div([]);

    return context.renderers.topAnnouncementBar(
      TopAnnouncementBarProps(
        message: widget.message,
        ctaText: widget.ctaText,
        ctaHref: widget.ctaHref,
        onCtaClick: widget.onCtaClick,
        onDismiss: _handleDismiss,
      ),
    );
  }
}

typedef ATopAnnouncementBar = ArcaneTopAnnouncementBar;
