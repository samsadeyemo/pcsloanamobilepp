import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pcsloan/common/widgets/signup_input_field.dart';
import 'package:pcsloan/common/widgets/signup_password_field.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String password = "";
  String _authMessage = 'Use fingerprint to log in';
  bool isLoading = false;
  final LocalAuthentication _auth = LocalAuthentication();
  final _authService = AuthService();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final types = await _auth.getAvailableBiometrics();
      debugPrint('isSupported: $isSupported');
      debugPrint('canCheck: $canCheck');
      debugPrint('available types: $types');

      final available = isSupported && canCheck && types.isNotEmpty;
      if (mounted) {
        setState(() {
          _biometricAvailable = available;
          _authMessage =
              available
                  ? 'Use fingerprint to log in'
                  : 'Biometric login not available on this device';
        });
      }
    } catch (e) {
      debugPrint('Biometric check error: $e');
      if (!mounted) return;
      setState(() => _authMessage = 'Biometric check error: $e');
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    // Guard: bail out early if not available
    if (!_biometricAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available')),
      );
      return;
    }

    setState(() => _authMessage = 'Authenticating...');

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Please verify your identity to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true, // keeps prompt alive across app switches
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() => _authMessage = 'Login successful!');
        // brief feedback (optional)
        await Future.delayed(const Duration(milliseconds: 350));
        context.go('/loan-redirect'); // your route
      } else {
        setState(() => _authMessage = 'Authentication failed or canceled.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _authMessage = 'Error: $e');
    }
  }

  //   Future<void> _loginUser() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     String rawPhone = _phoneController.text.trim();
  //     print('Raw phone number: $rawPhone');
  //     String formattedPhone = _normalizePhoneNumber(rawPhone);
  //   print('Formatted phone number: $formattedPhone');
  //     final result = await _authService.loginUser(
  //       phone: formattedPhone,
  //       password: _passwordController.text.trim(),
  //     );
  //     await LocalStorage.saveUser(result['data']['user']);
  //     print('User data saved: ${result['data']['user']}');
  //     await LocalStorage.saveToken(result['data']['token']);
  //     await LocalStorage.setHasLoan(result['data']['hasLoan']);
  //     String resultMessage = result["message"] ?? "Login successful";
  //     _showSnackBar(resultMessage, isError: false);
  //     context.go("/loan-redirect");
  //   } catch (e) {
  //     _showSnackBar(e.toString(), isError: true);
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      String rawPhone = _phoneController.text.trim();
      String formattedPhone = _normalizePhoneNumber(rawPhone);

      final result = await _authService.loginUser(
        phone: formattedPhone,
        password: _passwordController.text.trim(),
      );

      await LocalStorage.saveUser(result['data']['user']);
      await LocalStorage.saveToken(result['data']['accessToken']);
      await LocalStorage.setHasLoan(result['data']['hasLoan']);
      await LocalStorage.setHasLoginBefore(true);

      // ✅ Widget might be gone by now, so guard before touching UI
      if (!mounted) return;

      String resultMessage = result["message"] ?? "Login successful";
      _showSnackBar(resultMessage, isError: false);
      context.go("/loan-redirect");
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Normalizes Nigerian phone numbers into +234 format
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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);
    // final authNotifier = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
                          child: Image.asset('assets/icons/pcs_text.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Color(0xff0F2D62),
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Sign in to continue to your account",
                  style: TextStyle(
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignupInputField(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        hintText: '',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        isPhoneNumber: true,
                        validator:
                            (value) =>
                                value != null && value.length >= 10
                                    ? null
                                    : 'Number must be 10 digits',
                      ),
                      SignupPasswordField(
                        icon: Icons.lock_outline,
                        label: "Password",
                        hintText: "Enter your password",
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Password required";
                          if (value.length < 6)
                            return "Must be at least 6 characters";
                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go('/forgot-password-screen');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7C70DF),
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
                      padding: const EdgeInsets.only(top: 0, right: 0),
                      child: SizedBox(
                        width: 342,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _loginUser(),
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
                                "Login",
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

                SizedBox(height: 15),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(thickness: 2, color: Color(0xFFE5E7EB)),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SizedBox(
                    width: 342,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _authenticateWithFingerprint,

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
                            colors: [Color(0xffE5E7EB), Color(0xffA198FF)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/fingerprint.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Use Biometric Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xff4B5563),
                            fontSize: 14,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.go('/signUp');
                          },
                          child: Text(
                            "Create an Account",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
