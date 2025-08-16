import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_circle_text_badge.dart';
import 'package:pcsloan/common/widgets/custom_loan_app_bar.dart';
import 'package:pcsloan/common/widgets/gradient_action_button.dart';

class BvnVerificationScreen extends ConsumerStatefulWidget {
  const BvnVerificationScreen({super.key});

  @override
  ConsumerState<BvnVerificationScreen> createState() =>
      _BvnVerificationScreen();
}

class _BvnVerificationScreen extends ConsumerState<BvnVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  String bvnNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar:CustomLoanAppBar(title: 'Verification',),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
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
                          child: Icon(
                            Icons.question_mark_rounded,
                            color: Color(0xff7C70DF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Complete Your Verification',
                    style: TextStyle(color: Color(0xff0F2D62), fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Center(
                        child: Text(
                          'We need to verify your identity to ensure the',
                        ),
                      ),
                      Center(
                        child: Text(
                          'security of your loan application. This process is',
                        ),
                      ),
                      Center(child: Text('quick and secure.')),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  // color: Color(0xffd9dbf1),
                  width: 430,
                  height: 90,

                  decoration: BoxDecoration(
                    color: Color(0xffF9FAFB),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2.0, // Border thickness
                    ),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30, width: 10),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffA198FF),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '1',
                              style: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'BVN Verification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
                            ),
                          ),
                          Text(
                            "Enter your Bank Verification Number",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff4B5563),
                            ),
                          ),
                          Text(
                            "to verify your identity",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  // color: Color(0xffd9dbf1),
                  width: 430,
                  height: 90,

                  decoration: BoxDecoration(
                    color: Color(0xffF9FAFB),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2.0, // Border thickness
                    ),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30, width: 10),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffD1D5DB),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '2',
                              style: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'Facial Verification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
                            ),
                          ),
                          Text(
                            'Take a selfie to match with your BVN',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff4B5563),
                            ),
                          ),
                          Text(
                            "records",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff4B5563),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter BVN Number',
                  style: TextStyle(color: Color(0xff4B5563), fontSize: 16),
                ),
                SizedBox(height: 10),

                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '22012345678',
                    suffixIcon: Icon(Icons.person, color: Color(0xffADAEBC)),

                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xffADAEBC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2.0,
                      ), // On focus
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red), // On error
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                    ),
                    hintStyle: TextStyle(color: Color(0xffADAEBC)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      bvnNumber = value;
                    });
                  },
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
                              Icons.lock,
                              size: 25,
                              color: Color(0xff7C70DF),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your BVN is encrypted and stored securely. We only use it for identity verification purposes. It is a one time verification. ',
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
                SizedBox(height: 20),
                Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                SizedBox(height: 20),
                GradientActionButton(
                  text: "Proceed to Facial Verification",
                  size: 18,
                  onPressed: () {
                    context.push("/facial-verification-screen");
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      return null;
                    },
                    child: Text(
                      "Need help with BVN?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffA198FF),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
