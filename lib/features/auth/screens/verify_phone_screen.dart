import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/common/widgets/otp_count_down_widget.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhoneScreen extends ConsumerStatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  ConsumerState<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends ConsumerState<VerifyPhoneScreen> {
  String _phoneNumber = ""; // value we'll show in the Text widget
  bool _isLoading = true; // simple loading flag
  bool _verifying = false;
  String _otpCode = "";
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadPhoneNumberOnce();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

 Future<void> _loadPhoneNumberOnce() async {
  final data = await LocalStorage.getUser();
  print("User from local storage: $data");

  // Navigate into the nested structure
  final phoneNumber = data?['user']?['phone'] ?? '';

  if (!mounted) return;
  setState(() {
    _phoneNumber = phoneNumber;
    _isLoading = false;
  });
}



  Future<void> _verifyOtp() async {
    final prefs = await SharedPreferences.getInstance();
    print("na otp code for the first log: $_otpCode");
    if (_otpCode == "") return;
    setState(() => _verifying = true);
    try {
      final result = await _authService.verifyOtp(
        otp: _otpCode,
        phone: _phoneNumber,
      );
      print("na the result be dis $result");
      await prefs.setBool('phone_verified', true);
      String resultMessage = result["message"] ?? "Phone number verified successfully";
      _showSnackBar("$resultMessage" ?? "Phone number verified successfully", isError: false);
      context.go('/create-password');
    } catch (e) {
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
     finally {
      setState(() => _verifying = false);
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
              AppBar(
                title: Text(
                  'Verify Your Phone',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the verfication code sent to',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),

              _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                    _phoneNumber.isEmpty
                        ? 'No Phone-Number saved'
                        : _phoneNumber,

                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Color(0xff0F2D62),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.center,
                child: PinCodeFields(
                  length: 6,
                  boxSize: 45,
                  onCompleted: (code) {
                    // send to backend / verify
                    _otpCode = code;
                    _verifyOtp();
                    print('User entered code 🍀🍀: $code');
                  },
                ),
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_outlined,
                      color: Color(0xff908FDF),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Code expires in',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(width: 6),

                    OtpCountdown(totalSeconds: 180),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, right: 0),
                  child: SizedBox(
                    width: 342,
                    height: 50,
                    child: _gradientButton(
                      label: _verifying ? null : "Continue",
                      onPressed: _verifying ? null : _verifyOtp,
                      loading: _verifying,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn’t receive the code?",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xff4B5563),
                          fontSize: 14,
                        ),
                      ),

                      TextButton(
                        onPressed: () => _showSnackBar("Resend functionality not implemented yet."),

                        child: Text(
                          "Click to resend",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffA198FF),
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    return null;
                  },
                  child: Text(
                    "Change Phone Number",
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
    );
  }

  Widget _gradientButton({
    required String? label,
    required VoidCallback? onPressed,
    required bool loading,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child:
              loading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                  : Text(
                    label ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
        ),
      ),
    );
  }
}
