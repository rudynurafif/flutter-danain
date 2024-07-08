import 'package:flutter/material.dart';

class SlideWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final AxisDirection direction;

  const SlideWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.direction = AxisDirection.left,
  });

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant SlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child ||
        widget.duration != oldWidget.duration ||
        widget.direction != oldWidget.direction) {
      _initAnimation();
    }
  }

  void _initAnimation() {
    _controller.reset();
    _slideAnimation = Tween<Offset>(
      begin: _getOffsetBegin(),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  Offset _getOffsetBegin() {
    switch (widget.direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
      default:
        return const Offset(1, 0);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );
      },
    );
  }
}
