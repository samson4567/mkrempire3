import 'package:flutter/material.dart';

void showAnimatedPopup(BuildContext context, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedPopup(message: message),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

class _AnimatedPopup extends StatefulWidget {
  final String message;
  const _AnimatedPopup({required this.message});

  @override
  State<_AnimatedPopup> createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<_AnimatedPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100, // Adjust this value to change position
      left: MediaQuery.of(context).size.width * 0.5 - 75,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
