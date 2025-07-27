import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';

class TransactionPinScreen extends ConsumerStatefulWidget {
  const TransactionPinScreen({super.key});

  @override
  ConsumerState<TransactionPinScreen> createState() => _TransactionPinScreen();
}

class _TransactionPinScreen extends ConsumerState<TransactionPinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E7EB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar(
              //   title: Text(
              //     'Set Transaction PIN',
              //     style: TextStyle(
              //       fontFamily: 'Inter',
              //       fontSize: 24,
              //       color: Color(0xff0F2D62),
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              //   centerTitle: false,
              //   backgroundColor: Colors.transparent,
              //   elevation: 0,
              // ),
              const SizedBox(height: 25),

              Text(
                'Set Transaction PIN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: Color(0xff0F2D62),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Create a secure 4-digit PIN for your',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'transactions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Create 4 -digit PIN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.center,
                child: PinCodeFields(
                  length: 4,
                  boxSize: 60,
                  onCompleted: (code) {
                    // send to backend / verify
                    // print('User entered code: $code');
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Confirm 4-digit PIN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.center,
                child: PinCodeFields(
                  length: 4,
                  boxSize: 60,
                  onCompleted: (code) {
                    // send to backend / verify
                    // print('User entered code: $code');
                  },
                ),
              ),
              const SizedBox(height: 24),

              Container(
                // color: Color(0xffd9dbf1),
                width: 400,
                height: 70,
                child: Row(
                  children: [
                    const SizedBox(height: 25, width: 30,),

                    Icon(
                      Icons.shield_sharp,
                      size: 20,
                      color: Color(0xffA198FF),
                    ),
                    

                    Column(
                      children: [
                        const SizedBox(height: 17, width: 8),
                        Text(
                          'This PIN will be required to authorize',
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ), 
                        Text(
                          "any financial activity on your account",
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffd9dbf1),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2.0, // Border thickness
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              const SizedBox(height: 50),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          context.go("/account-created-screen");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Set Pin",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
