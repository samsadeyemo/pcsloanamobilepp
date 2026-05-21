import 'package:flutter/material.dart';
import 'package:pcsloan/features/loan_application/presentation/facial_verification_screen.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class LoanReviewCard extends StatefulWidget {
  final String status; // 'review' | 'verification' | 'cancelled'
  final double? amountRequested;
  final String? tenure;

  const LoanReviewCard({
    super.key,
    required this.status,
    this.amountRequested,
    this.tenure,
  });

  @override
  State<LoanReviewCard> createState() => _LoanReviewCardState();
}

class _LoanReviewCardState extends State<LoanReviewCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  bool get isVerification => widget.status == 'verification';
  bool get isCancelled => widget.status == 'cancelled';

  // Gradient colors based on status
  List<Color> get _gradientColors {
    if (isCancelled) {
      return [
        const Color(0xffC0392B),
        const Color(0xffE74C3C),
      ];
    }
    if (isVerification) {
      return [
        const Color(0xff7C70DF),
        const Color(0xffA78BFA),
      ];
    }
    return [
      const Color(0xff7C70DF),
      const Color(0xff9D8FE8),
    ];
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Stack(
        children: [
          // Animated glow background
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isCancelled
                              ? const Color(0xffE74C3C)
                              : const Color(0xff7C70DF))
                          .withOpacity(_pulseAnimation.value * 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    if (isVerification || isCancelled)
                      BoxShadow(
                        color: (isCancelled
                                ? const Color(0xffFC8181)
                                : const Color(0xffA78BFA))
                            .withOpacity(_pulseAnimation.value * 0.15),
                        blurRadius: 25,
                        spreadRadius: 1,
                      ),
                  ],
                ),
              );
            },
          ),

          // Main card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Animated grid pattern
                  _buildGridPattern(),

                  // Shimmer effect
                  if (isVerification || isCancelled) _buildShimmerEffect(),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIconSection(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 4),
                              _buildContent(),
                              const SizedBox(height: 10),
                              _buildActionSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPattern() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return CustomPaint(
            painter: GridPatternPainter(
              color: Colors.white.withOpacity(0.06),
              offset: _shimmerAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: [
                  (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                  _shimmerAnimation.value.clamp(0.0, 1.0),
                  (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconSection() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isVerification || isCancelled)
                AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateController.value * 2 * math.pi,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Icon(
                  isCancelled
                      ? Icons.cancel_rounded
                      : isVerification
                          ? Icons.verified_rounded
                          : Icons.pending_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 6 * _pulseAnimation.value,
                    spreadRadius: 1.5 * _pulseAnimation.value,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          isCancelled
              ? 'CANCELLED'
              : isVerification
                  ? 'APPROVED'
                  : 'UNDER REVIEW',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isCancelled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your loan application has been cancelled. Please contact our support team to resolve this issue.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
          if (widget.amountRequested != null || widget.tenure != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.amountRequested != null) ...[
                    const Icon(Icons.monetization_on_outlined,
                        color: Colors.white70, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      formatCurrency(widget.amountRequested!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                  if (widget.amountRequested != null && widget.tenure != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 1,
                      height: 12,
                      color: Colors.white38,
                    ),
                  if (widget.tenure != null) ...[
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.white70, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.tenure} Months',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    }

    return Text(
      isVerification
          ? 'Complete your biometric verification to unlock your funds'
          : 'Your application is being reviewed. We\'ll notify you shortly',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.9),
        height: 1.4,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildActionSection() {
    if (isCancelled) {
      return Row(
        children: [
          // Try Again button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Route to loan application
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh_rounded,
                        color: Color(0xffC0392B), size: 15),
                    SizedBox(width: 5),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffC0392B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Contact Support button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Route to support / open contact screen
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.headset_mic_rounded,
                        color: Colors.white, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'Get Support',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (isVerification) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SmileIDVerificationScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white
                        .withOpacity(_pulseAnimation.value * 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fingerprint_rounded,
                      color: Color(0xff7C70DF), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Start Verification',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff7C70DF),
                      fontFamily: 'Inter',
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Color(0xff7C70DF), size: 16),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.schedule_rounded,
              color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '24-48 hours',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final Color color;
  final double offset;

  GridPatternPainter({required this.color, required this.offset});

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
        Offset(i + offsetX, 0),
        Offset(i + offsetX, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridPatternPainter oldDelegate) {
    return oldDelegate.offset != offset || oldDelegate.color != color;
  }
}