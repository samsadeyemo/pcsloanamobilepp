import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/service/auth_service.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreen();
}

class _VerifyOtpScreen extends ConsumerState<VerifyOtpScreen> {
  //   bool _obscurePassword = true;
  //   bool _obscurePassword1 = true;
  //   String password = "";
  //   String password1 = "";
  //   String otpCode = "";
  //   bool _verifying = false;

  // String? _passwordValidator(String? value) {
  //     if (value == null || value.isEmpty) return "Password cannot be empty";
  //     if (value.length < 8) return "Password must be at least 8 characters";

  //     final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
  //     final hasNumber = RegExp(r'\d').hasMatch(value);
  //     final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  //     if (!hasLetter || !hasNumber || !hasSpecial) {
  //       return "Password must include letters, numbers & special chars";
  //     }

  //     return null;
  //   }

  // String? _confirmPasswordValidator(String? value) {
  //     if (value == null || value.isEmpty) return "Please confirm password";
  //     if (value != password) return "Passwords do not match";
  //     return null;
  //   }

  // Future<void> _resetPassword() async {
  //   FocusScope.of(context).unfocus();
  //   setState(() => _verifying = true);

  //   }

  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _verifying = false;

  String password = "";
  String confirmPassword = "";
  String otpCode = "";

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Password cannot be empty";
    if (value.length < 8) return "Password must be at least 8 characters";

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return "Password must include letters, numbers & special chars";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Please confirm password";
    if (value != password) return "Passwords do not match";
    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (otpCode.length != 6) {
      _showError("Enter a valid 6-digit OTP");
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _verifying = true);

    try {
      await _authService.resetPassword(
        otp: otpCode,
        newPassword: password,
        confirmNewpassword: confirmPassword,
      );

      if (!mounted) return;
      context.go('/password-change-success');
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

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
                child: Form(
                  key: _formKey,
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
                            otpCode = code;
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 0,
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Color(0xff6B7280),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                obscureText: _obscurePassword,
                                onChanged: (value) => password = value,
                                validator: _passwordValidator,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 0,
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Color(0xff6B7280),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                obscureText: _obscureConfirmPassword,
                                onChanged: (value) => confirmPassword = value,
                                validator: _confirmPasswordValidator,
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
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureConfirmPassword
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
                              onPressed: _verifying ? null : _resetPassword,
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
                                  child:
                                      _verifying
                                          ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                          : Text(
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
                            context.go('/signin');
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
                      SizedBox(height: 140),

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shield_outlined, size: 14),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
