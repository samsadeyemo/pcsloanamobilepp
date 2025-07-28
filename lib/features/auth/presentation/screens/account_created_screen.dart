import 'package:flutter/material.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[800],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
            color: Color(0xffE5E7EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xffd9dbf1),

                      child: Icon(Icons.check, size: 40, color: Color(0xff7C70DF)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Account Created!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0F2D62),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your PCS Loan account has been successfully created. You can now access all features.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 280,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              // context.go("/account-created-screen");
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
                                  colors: [
                                    Color(0xff7C70DF),
                                    Color(0xffA198FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Continue",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

