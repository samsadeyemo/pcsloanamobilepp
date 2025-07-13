import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 1.0),
                    child: _threeCircleStack(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, right: 1.0),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffA198FF).withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/icons/pcs_text.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,

                  child: Padding(
                    padding: const EdgeInsets.only(top: 150.0, right: 1.0),
                    child: Text(
                      "Welcome to PCS Loan",
                      style: TextStyle(
                        color: Color(0xff0F2D62),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200.0, right: 1.0),
                    child: Text(
                      "Your trusted partner for hassle-free loans",
                      style: TextStyle(
                        color: Color(0xff0F2D62),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0),
                    child: SizedBox(
                      width: 342,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/signIn');
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
                              "Sign In",
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
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150, right: 0),
                    child: SizedBox(
                      width: 342,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/getStartedScreen');
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
                              colors: [Color(0xffFFFFFF), Color(0xffFFFFFF)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Color(0xffA198FF),
                              width: 2,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
                              style: const TextStyle(
                                color: Color(0xffA198FF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 1.0),
                    child: _threeCircleStack(),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Text(
                      "By continuing, you agree to our",
                      style: TextStyle(fontSize: 14,
                      fontFamily: "Inter"
                      ),
                    ),
                  ),
                ),
                  
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: TextButton(
                      onPressed: () {
                        print("x");
                      },
                      child: Text(
                        "Terms of Service and Privacy Policy",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffA198FF),
                          fontFamily: "Inter"
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined),
                        SizedBox(width: 8),
                        Text("Secure & Licensed Platform",
                        style: TextStyle(fontFamily: "Inter", color: Color(0xff4B5563), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _threeCircleStack() {
  return Stack(
    alignment: Alignment.center,
    children: [
      //first Circle
      Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffA198FF).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      //second Circle
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffA198FF).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),

      //third circle
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffA198FF).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    ],
  );
}
