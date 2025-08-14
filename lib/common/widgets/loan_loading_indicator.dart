import 'package:flutter/material.dart';

class DualRingSpinner extends StatefulWidget {
  final IconData icon;
  final String message;
  final double size;

  const DualRingSpinner({
    super.key,
    this.icon = Icons.show_chart,
    this.message = "Fetching the best loan for you...",
    this.size = 100,
  });

  @override
  State<DualRingSpinner> createState() => _DualRingSpinnerState();
}

class _DualRingSpinnerState extends State<DualRingSpinner>
    with TickerProviderStateMixin {
  late AnimationController _outerController;
  late AnimationController _innerController;
  late Animation<double> _outerScale;
  late Animation<double> _innerScale;

  @override
  void initState() {
    super.initState();

    _outerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _innerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _outerScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _outerController, curve: Curves.easeInOut),
    );

    _innerScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _innerController, curve: Curves.easeInOut),
    );

    _outerController.repeat(reverse: true);
    _innerController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double ringWidth = 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _outerScale,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff7C70DF), // Purple
                    width: ringWidth,
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: _innerScale,
              child: Container(
                width: widget.size * 0.75,
                height: widget.size * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffF3F4F6), // Grey
                    width: ringWidth,
                  ),
                ),
              ),
            ),
            Icon(
              widget.icon,
              size: widget.size * 0.3,
              color: const Color(0xff4B5563),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.message,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff4B5563),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
