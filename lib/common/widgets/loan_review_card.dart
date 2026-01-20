// import 'package:flutter/material.dart';
// import 'package:pcsloan/features/loan_application/presentation/facial_verification_screen.dart';

// class LoanReviewCard extends StatefulWidget {
//   final String status; // 'review' or 'verification'

//   const LoanReviewCard({super.key, required this.status});

//   @override
//   State<LoanReviewCard> createState() => _LoanReviewCardState();
// }

// class _LoanReviewCardState extends State<LoanReviewCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(
//       begin: 0.6,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   bool get isVerification => widget.status == 'verification';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Animated Icon Container
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors:
//                     isVerification
//                         ? [
//                           const Color(0xff10B981).withOpacity(0.15),
//                           const Color(0xff7C70DF).withOpacity(0.15),
//                         ]
//                         : [
//                           const Color(0xff7C70DF).withOpacity(0.15),
//                           const Color(0xffFBBF24).withOpacity(0.15),
//                         ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: AnimatedBuilder(
//               animation: _pulseAnimation,
//               builder: (context, child) {
//                 return Opacity(
//                   opacity: _pulseAnimation.value,
//                   child: Icon(
//                     isVerification
//                         ? Icons.shield_rounded
//                         : Icons.hourglass_empty_rounded,
//                     color:
//                         isVerification
//                             ? const Color(0xff10B981)
//                             : const Color(0xffFBBF24),
//                     size: 24,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Text Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isVerification
//                       ? 'Application Approved'
//                       : 'Application Under Review',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xff0F2D62),
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   isVerification
//                       ? 'Congratulations! Your application has been approved. Please complete your BVN verification to proceed.'
//                       : 'Your loan application is currently being reviewed. You will be notified once a decision has been made.',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     height: 1.3,
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Animated Status Badge or Button
//                 isVerification
//                     ? _buildGlowingButton(context)
//                     : _buildPendingBadge(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPendingBadge() {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xff7C70DF).withOpacity(0.15),
//                 const Color(0xffFBBF24).withOpacity(0.15),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Opacity(
//                 opacity: _pulseAnimation.value,
//                 child: Container(
//                   width: 5,
//                   height: 5,
//                   decoration: const BoxDecoration(
//                     color: Color(0xffFBBF24),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0xffFBBF24),
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 5),
//               const Text(
//                 'Pending Review',
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xff7C70DF),
//                   fontFamily: 'Inter',
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildGlowingButton(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SmileIDVerificationScreen(),
//               ),
//             );
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [const Color(0xff10B981), const Color(0xff7C70DF)],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(
//                     0xff10B981,
//                   ).withOpacity(_pulseAnimation.value * 0.5),
//                   blurRadius: 12,
//                   spreadRadius: 2,
//                 ),
//                 BoxShadow(
//                   color: const Color(
//                     0xff7C70DF,
//                   ).withOpacity(_pulseAnimation.value * 0.3),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.verified_user_rounded,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 6),
//                 const Text(
//                   'Complete Verification',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     fontFamily: 'Inter',
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:pcsloan/features/loan_application/presentation/facial_verification_screen.dart';
import 'dart:math' as math;

class LoanReviewCard extends StatefulWidget {
  final String status; // 'review' or 'verification'

  const LoanReviewCard({super.key, required this.status});

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
                      color: const Color(0xff7C70DF).withOpacity(
                        _pulseAnimation.value * 0.25,
                      ),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    if (isVerification)
                      BoxShadow(
                        color: const Color(0xffA78BFA).withOpacity(
                          _pulseAnimation.value * 0.15,
                        ),
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
                colors: isVerification
                    ? [
                        const Color(0xff7C70DF),
                        const Color(0xffA78BFA),
                      ]
                    : [
                        const Color(0xff7C70DF),
                        const Color(0xff9D8FE8),
                      ],
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
                  if (isVerification) _buildShimmerEffect(),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
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
              // Rotating ring
              if (isVerification)
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
              // Icon
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Icon(
                  isVerification
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
          isVerification ? 'APPROVED' : 'UNDER REVIEW',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(
                      _pulseAnimation.value * 0.4,
                    ),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fingerprint_rounded,
                    color: Color(0xff7C70DF),
                    size: 18,
                  ),
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
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xff7C70DF),
                      size: 16,
                    ),
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
          child: const Icon(
            Icons.schedule_rounded,
            color: Colors.white,
            size: 14,
          ),
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