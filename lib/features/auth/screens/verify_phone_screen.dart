// verify_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/common/widgets/otp_count_down_widget.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class VerifyPhoneScreen extends ConsumerStatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  ConsumerState<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends ConsumerState<VerifyPhoneScreen> {
  String _phoneNumber = "";
  bool _isLoading = true;
  bool _verifying = false;
  String _otpCode = "";
  final _authService = AuthService();

  // Countdown control
  final GlobalKey<OtpCountdownState> _countdownKey =
      GlobalKey<OtpCountdownState>();
  bool _canResend = false; // show/hide resend button
  bool _isExpired = false; // show expired message instead of timer row
  bool _resending = false; // in-flight resend UI freeze

  @override
  void initState() {
    super.initState();
    _loadPhoneNumberOnce();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _loadPhoneNumberOnce() async {
    final data = await LocalStorage.getUser();
     if (!mounted) return;
    final phoneNumber = data?['user']?['phone'] ?? '';

    
    setState(() {
      _phoneNumber = phoneNumber;
      _isLoading = false;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpCode == "") return;

    setState(() => _verifying = true);

    try {
      final result = await _authService.verifyOtp(
        otp: _otpCode,
        phone: _phoneNumber,
      );
      if (!mounted) return;
      await LocalStorage.setPhoneVerified(true);
      if (!mounted) return;
      String resultMessage =
          result["message"] ?? "Phone number verified successfully";
      _showSnackBar(resultMessage, isError: false);
      context.go('/create-password');
    } catch (e) {
       if (!mounted) return;
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );

      // Clear entered OTP so user can retry
      _clearPinCodeFields();
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _clearPinCodeFields() {
    // Force rebuild of PinCodeFields by updating state
    setState(() {
      _otpCode = "";
    });
  }

  Future<bool> _attemptResend() async {
    final data = await LocalStorage.getUser();
    if (!mounted) return false;
    final employeeId = data?['user']?['employee_id'] ?? '';
    if (employeeId == "") return false;
    try {
      final result = await _authService.resendVerificationCode(employeeId);
      if (!mounted) return false;
      String resultMessage = result["message"] ?? "OTP resent successfully";
      _showSnackBar(resultMessage, isError: false);
      return true;
    } catch (e) {
       if (!mounted) return false;
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
      return false;
    }
  }

  Future<void> _onResendPressed() async {
    if (_resending) return; // safety
    setState(() {
      _resending = true; // freeze UI, change text
    });

    final success = await _attemptResend();
    if (!mounted) return;
    if (success) {
      // hide resend button and restart timer
      setState(() {
        _resending = false;
        _canResend = false;
        _isExpired = false;
      });
      _countdownKey.currentState?.reset();
    } else {
      // show button again for retry; expired message stays
      setState(() {
        _resending = false;
        _canResend = true;
        _isExpired = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const fadeDuration = Duration(milliseconds: 350);
    const double buttonHeight = 50;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: const Text(
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
                const Text(
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
                          : _phoneNumber.startsWith('+')
                          ? _phoneNumber
                          : '+$_phoneNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        color: Color(0xff0F2D62),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                const SizedBox(height: 30),

                // PIN input with keyboard freeze during verifying
                Align(
                  alignment: Alignment.center,
                  child: FocusScope(
                    canRequestFocus: !_verifying,
                    child: PinCodeFields(
                      length: 6,
                      boxSize: 45,
                      onCompleted: (code) {
                        _otpCode = code;
                        _verifyOtp();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Timer row or expired message (AnimatedSwitcher for fade)
                Align(
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: fadeDuration,
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child:
                        _isExpired
                            ? Row(
                              key: const ValueKey('expired'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Code has expired, try resending',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              key: const ValueKey('timer'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.timelapse_outlined,
                                  color: Color(0xff908FDF),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Code expires in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                OtpCountdown(
                                  key: _countdownKey,
                                  totalSeconds: 300,
                                  onExpired: () {
                                    if (!mounted) return;
                                    setState(() {
                                      _isExpired = true;
                                      _canResend = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedOpacity(
                      duration: fadeDuration,
                      opacity: _canResend ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                      child:
                          _canResend
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Didn’t receive the code?",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xff4B5563),
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        _resending ? null : _onResendPressed,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      _resending
                                          ? "Resending…"
                                          : "Click to resend",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xffA198FF),
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                ),

                // Spinner replacing "Continue" button
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 342,
                    height: buttonHeight,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          _verifying
                              ? SizedBox(
                                key: const ValueKey('verifying_spinner'),
                                height: buttonHeight,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                              : const SizedBox(
                                key: ValueKey('empty_space'),
                                height: buttonHeight,
                              ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Resend row -- invisible while countdown runs.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
