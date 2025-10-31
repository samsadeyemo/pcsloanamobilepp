import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_input_field.dart';
import 'package:pcsloan/service/auth_service.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends ConsumerState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _sending = false;
  String _phoneNumber = '';
  final _authService = AuthService();

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String _normalizePhoneNumber(String input) {
    String phone = input.replaceAll(RegExp(r'\s+'), ''); // remove spaces

    if (phone.startsWith('+234')) {
      // ✅ Already correct
      return phone;
    } else if (phone.startsWith('234')) {
      // ✅ Missing '+'
      return phone;
    } else if (phone.startsWith('0')) {
      // ✅ Convert 080... → +23480...
      return '234${phone.substring(1)}';
    } else {
      // ⚠️ Fallback (user just typed e.g. 8088993491)
      return '234$phone';
    }
  }

  Future<void> _submitPhoneNumber() async {
    if (_sending) return; 
    if (_phoneNumber == "") return;
    String cleanPhoneNumber = _normalizePhoneNumber(_phoneNumber);
    setState(() => _sending = true);

    try {
      final result = await _authService.forgetPassword(phone: cleanPhoneNumber);
      String resultMessage = result['message'] ?? 'OTP sent successfully';
      _showSnackBar(resultMessage, isError: false);
      context.go('/verify-password-otp');
    } catch (e) {
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: Color(0xff0F2D62),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Enter the phone number linked to your account',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xff0F2D62),
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      icon: Icons.phone,
                      label: "",
                      hintText: 'Enter your Phone Number',
                      onChanged: (value) => _phoneNumber = value,
                      validator:
                          (value) =>
                              value != null && value.isNotEmpty
                                  ? null
                                  : 'Phone Number is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, right: 0),
                  child: SizedBox(
                    width: 342,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitPhoneNumber,
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
                            _sending
                            ? "sending..."
                            :"Send OTP",
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
            ],
          ),
        ),
      ),
    );
  }
}
