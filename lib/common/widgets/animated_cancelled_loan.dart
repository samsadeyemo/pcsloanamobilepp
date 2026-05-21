import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class AnimatedCancelledLoan extends StatefulWidget {
  final double amountRequested;
  final String tenure;
  final String loanStatus; // 'CANCELLED' or 'CLOSED'
  final VoidCallback? onTryAgain;
  final VoidCallback? onContactSupport;

  const AnimatedCancelledLoan({
    Key? key,
    required this.amountRequested,
    required this.tenure,
    required this.loanStatus,
    this.onTryAgain,
    this.onContactSupport,
  }) : super(key: key);

  @override
  State<AnimatedCancelledLoan> createState() => _AnimatedCancelledLoanState();
}

class _AnimatedCancelledLoanState extends State<AnimatedCancelledLoan>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _shimmerController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _shimmerController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  bool get isClosed => widget.loanStatus == 'CLOSED';

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xff4A3FC0),  // deep rich purple
                    const Color(0xff6B5ED6),  // mid purple
                    const Color(0xff7C70DF),  // brand purple
                    const Color(0xff6658CC),  // slightly deeper to close
                  ],
                  stops: const [0.0, 0.35, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff4A3FC0).withOpacity(
                      0.35 * _pulseAnimation.value,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: const Color(0xff7C70DF).withOpacity(
                      0.2 * _pulseAnimation.value,
                    ),
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Subtle grid pattern in background
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _GridPatternPainter(
                            color: Colors.white.withOpacity(0.05),
                            offset: (_shimmerController.value * 2) - 1,
                          ),
                        );
                      },
                    ),
                  ),

                  // Main content
                  Column(
                    children: [
                      // Icon with rotating ring
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, _) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(
                                    0.15 * _pulseAnimation.value,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Rotating dashed ring
                                AnimatedBuilder(
                                  animation: _rotateController,
                                  builder: (context, _) {
                                    return Transform.rotate(
                                      angle: _rotateController.value *
                                          2 *
                                          math.pi,
                                      child: CustomPaint(
                                        size: const Size(70, 70),
                                        painter: _DashedCirclePainter(
                                          color:
                                              Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Transform.scale(
                                  scale: 0.85 +
                                      (_pulseAnimation.value * 0.15),
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Status label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, _) {
                              return Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffFF6B6B),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffFF6B6B),
                                      blurRadius:
                                          8 * _pulseAnimation.value,
                                      spreadRadius:
                                          2 * _pulseAnimation.value,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isClosed ? 'LOAN CLOSED' : 'LOAN CANCELLED',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              letterSpacing: 1.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Amount
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) {
                              return Opacity(
                                opacity: _pulseAnimation.value * 0.35,
                                child: Text(
                                  formatCurrency(widget.amountRequested),
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xffD4CFFF),
                                  Colors.white,
                                ],
                                stops: [0.0, 0.5, 1.0],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              formatCurrency(widget.amountRequested),
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        isClosed
                            ? 'This loan has been closed. Please contact our support team if you believe this is an error.'
                            : 'Your loan application was cancelled. Please try again or contact our support team to resolve this.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Tenure pill
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                  0.2 +
                                      (_shimmerController.value * 0.2),
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  '${widget.tenure} Months Tenure',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // CTAs
                      Row(
                        children: [
                          // Try Again
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.onTryAgain,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh_rounded,
                                      color: Color(0xff7C70DF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff7C70DF),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Contact Support
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.onContactSupport,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.headset_mic_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Get Support',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Painters ────────────────────────────────────────────────────────────────

class _GridPatternPainter extends CustomPainter {
  final Color color;
  final double offset;

  _GridPatternPainter({required this.color, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 30.0;
    final offsetX = (offset * gridSize) % gridSize;

    for (double i = -gridSize; i < size.width + gridSize; i += gridSize) {
      canvas.drawLine(
          Offset(i + offsetX, 0), Offset(i + offsetX, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPatternPainter old) =>
      old.offset != offset || old.color != color;
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const dashCount = 12;
    const dashAngle = (2 * math.pi) / dashCount;
    const gapFraction = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter old) => false;
}