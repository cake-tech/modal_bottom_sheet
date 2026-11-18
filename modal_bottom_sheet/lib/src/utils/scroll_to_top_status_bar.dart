import 'package:flutter/material.dart';

typedef StatusBarGestureDetectorCallback = void Function(BuildContext context);

/// Widget that that will make the [scrollController] to scroll the top
/// when tapped on the status bar
///
/// Extracted from [Scaffold] and used in [Sheet]
class StatusBarGestureDetector extends StatefulWidget {
  const StatusBarGestureDetector({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;

  final StatusBarGestureDetectorCallback onTap;

  @override
  State<StatusBarGestureDetector> createState() =>
      _StatusBarGestureDetectorState();
}

class _StatusBarGestureDetectorState extends State<StatusBarGestureDetector> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (context) {
      final view = View.of(context);
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: view.padding.top / view.devicePixelRatio,
          width: double.infinity,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onTap(context),
            // iOS accessibility automatically adds scroll-to-top to the clock in the status bar
            excludeFromSemantics: true,
          ),
        ),
      );
    },
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Overlay.of(context, rootOverlay: true).insert(_entry);
    });
  }

  @override
  void dispose() {
    if (_entry.mounted) _entry.remove();
    _entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
