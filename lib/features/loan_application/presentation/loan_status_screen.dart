import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_loading_indicator.dart';

class LoanStatusScreen extends ConsumerStatefulWidget {
  const LoanStatusScreen({super.key});
  @override
  ConsumerState<LoanStatusScreen> createState() => _LoanStatusScreen();
}

class _LoanStatusScreen extends ConsumerState<LoanStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 40,
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF3F4F6),
              ),
              child: Center(
                child: FittedBox(
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 20,
                    color: Color(0xff4B5563),
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xffFFFFFF),
        titleSpacing: 0,
        title: Text(
          'Were Reviewing Your Application',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff0F2D62),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
              padding: const EdgeInsets.all(20),
      child: Column(
      
       
        children: [
          SizedBox(height: 80),
          Align(
            alignment: Alignment.center,
            child: DualRingSpinner(
              message: "Processing your application...",
              icon: Icons.trending_up_outlined,
              size: 150,
            ),
          ),

          SizedBox(
            height: 90,
            ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Align(
                                alignment: Alignment.center,
                                child: Icon(
                                Icons.info,
                                size: 25,
                                color: Color(0xff7C70DF),
                              ),
                              ),

                          SizedBox(height: 8),
                          Text(
                            'Our system is reviewing you application. This usually takes 3-5 seconds.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

               
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          "You wll be automatically redirected to your loan offer",
                          style: TextStyle(
                            color: Color(0xff4B5563),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
        ],
      ),
      ),
    );
  }
}
