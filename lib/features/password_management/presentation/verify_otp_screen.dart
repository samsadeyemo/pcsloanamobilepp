import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreen();
}

class _VerifyOtpScreen extends ConsumerState<VerifyOtpScreen> {
  bool _obscurePassword = true;
  bool _obscurePassword1 = true;
  String password = "";
  String password1 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  'Enter the 6-digit OTP sent to your phone',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 40),

                Align(
                  alignment: Alignment.center,
                  child: PinCodeFields(
                    length: 6,
                    boxSize: 45,
                    onCompleted: (code) {
                      // send to backend / verify
                      // print('User entered code: $code');
                    },
                  ),
                ),

                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          obscureText: _obscurePassword,
                          onChanged: (value) => password = value,
                          validator:
                              (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : "Password too short try again",
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter new password',
                            hintStyle: TextStyle(
                              color: Color(0xFFADAEBC),
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            // contentPadding: EdgeInsets.zero,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xff9CA3AF),
                                size: 20,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          obscureText: _obscurePassword1,
                          onChanged: (value) => password1 = value,
                          validator:
                              (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : "Password too short try again",
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Confirm new password',
                            hintStyle: TextStyle(
                              color: Color(0xFFADAEBC),
                              fontSize: 16,
                              fontFamily: "Inter",
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            // contentPadding: EdgeInsets.zero,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword1 = !_obscurePassword1;
                                });
                              },
                              icon: Icon(
                                _obscurePassword1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xff9CA3AF),
                                size: 20,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0),
                    child: SizedBox(
                      width: 342,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/verify-password-otp');
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
                              "Reset Password",
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
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.go('/forgot-password-screen');
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C70DF),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.go('/forgot-password-screen');
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C70DF),
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
SizedBox(height: 100),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child:Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          ),
                        SizedBox(width: 8),
                        Text(
                          "Your information is secure",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xff4B5563),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                )
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
