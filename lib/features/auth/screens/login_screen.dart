import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pcsloan/common/widgets/signup_input_field.dart';
import 'package:pcsloan/common/widgets/signup_password_field.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';
import 'package:pcsloan/auth_storage/token_storage.dart';

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
  bool _biometricEnabled = false;
  bool _hasLoggedInBefore = false;

  @override
  void initState() {
    super.initState();
    // _clearExpiredSession();
    _initializeBiometric();
    _loadSavedPhoneNumber();
  }


  Future<void> _loadSavedPhoneNumber() async {
    try {
      final data = await LocalStorage.getUser();
      if (!mounted) return;
      final rawPhone = data?['phone'];

      if (rawPhone != null && rawPhone.isNotEmpty) {
        String formattedPhone = _formatPhoneForDisplay(rawPhone);

        if (mounted) {
          setState(() {
            _phoneController.text = formattedPhone;
          });
        }
      }
    } catch (e) {
       if (!mounted) return;
      debugPrint('Error loading phone number: $e');
    }
  }

  // Add this new method to format the phone number for display
  String _formatPhoneForDisplay(String phone) {
    // Remove any whitespace
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');

    // Remove country code (234 or +234) to show local format
    if (cleanPhone.startsWith('+234')) {
      return cleanPhone.substring(4);
    } else if (cleanPhone.startsWith('234')) {
      return cleanPhone.substring(3);
    } else if (cleanPhone.startsWith('0')) {
      return cleanPhone; // Already in local format
    } else {
      return cleanPhone; // Add leading 0
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _initializeBiometric() async {
    try {
      // Check device biometric support
      final isSupported = await _auth.isDeviceSupported();
       if (!mounted) return;
      final canCheck = await _auth.canCheckBiometrics;
       if (!mounted) return;
      final types = await _auth.getAvailableBiometrics();
       if (!mounted) return;

      // Check if user has enabled biometric in settings
      final isEnabled = await LocalStorage.isBiometricEnabled();
       if (!mounted) return;
      // Check if user has logged in before
      final hasLoginBefore = await LocalStorage.hasLoginBefore();
       if (!mounted) return;
      final available = isSupported && canCheck && types.isNotEmpty;

      if (mounted) {
        setState(() {
          _biometricAvailable = available;
          _biometricEnabled = isEnabled;
          _hasLoggedInBefore = hasLoginBefore;

          // Update message based on availability
          if (!available) {
            _authMessage = 'Biometric not available on this device';
          } else if (!isEnabled) {
            _authMessage = 'Enable biometric in security settings';
          } else if (!hasLoginBefore) {
            _authMessage = 'Login once to enable biometric';
          } else {
            _authMessage = 'Use fingerprint to log in';
          }
        });
      }
    } catch (e) {
       if (!mounted) return;
      debugPrint('Biometric initialization error: $e');
      if (mounted) {
        setState(() {
          _biometricAvailable = false;
          _biometricEnabled = false;
          _authMessage = 'Biometric check error';
        });
      }
    }
  }

  // Check if biometric button should be enabled
  bool get _canUseBiometric =>
      _biometricAvailable && _biometricEnabled && _hasLoggedInBefore;


  Future<void> _authenticateWithFingerprint() async {
    if (!_canUseBiometric) {
      String message;
      if (!_biometricAvailable) {
        message = 'Biometric authentication not available on this device';
      } else if (!_biometricEnabled) {
        message = 'Please enable biometric in security settings first';
      } else if (!_hasLoggedInBefore) {
        message = 'Please login with password first';
      } else {
        message = 'Biometric authentication not available';
      }

      _showSnackBar(message, isError: true);
      return;
    }

    setState(() => _authMessage = 'Authenticating...');

    try {
      // Step 1: Authenticate with biometric
      final authenticated = await _auth.authenticate(
        localizedReason: 'Please verify your identity to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (!mounted) return;

      if (!authenticated) {
        setState(() => _authMessage = 'Authentication failed or canceled');
        _showSnackBar('Biometric authentication failed', isError: true);
        return;
      }

      // Step 2: Biometric successful - now refresh tokens
      setState(() {
        _authMessage = 'Refreshing session...';
        isLoading = true;
      });

      try {
        debugPrint("🔐 Starting token refresh...");

        // Call the refresh token endpoint via AuthService
        final result = await _authService.refreshToken();
         if (!mounted) return;

        

        // Check if we're still on this screen (not navigated away by onAuthenticationFailed)
        if (!ModalRoute.of(context)!.isCurrent) {
          return;
        }

        // Save the new tokens and user data
        if (result['data'] != null) {
          final data = result['data'];

          // Use the GLOBAL tokenStorage from main.dart
          final tokenStorage = TokenStorage();

          // Check which token format the backend is using
          final accessToken = data['accessToken'] ?? data['access_token'];
          final refreshToken = data['refreshToken'] ?? data['refresh_token'];

          debugPrint(
            "💾 Saving tokens - access: ${accessToken != null}, refresh: ${refreshToken != null}",
          );

          if (accessToken != null && refreshToken != null) {
            await tokenStorage.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
             if (!mounted) return;
          } else if (accessToken != null) {
            await tokenStorage.saveAccessToken(accessToken);
             if (!mounted) return;
          } else if (refreshToken != null) {
            await tokenStorage.saveRefreshToken(refreshToken);
             if (!mounted) return;
          }

          // Also save to LocalStorage for compatibility
          if (accessToken != null) {
            await LocalStorage.saveToken(accessToken);
             if (!mounted) return;
          }

          // Update user data if present
          if (data['user'] != null) {
            await LocalStorage.saveUser(data['user']);
             if (!mounted) return;
          }

          // Update loan status if present
          if (data['hasLoan'] != null) {
            await LocalStorage.setHasLoan(data['hasLoan']);
             if (!mounted) return;
          }

          // Verify tokens were saved
          final savedRefresh = await tokenStorage.getRefreshToken();
           if (!mounted) return;
          debugPrint(
            "🔍 Verification - refresh token saved: ${savedRefresh != null}",
          );
        }

        setState(() => _authMessage = 'Login successful!');
        _showSnackBar('Login successful!');

        // Brief feedback before navigation
        await Future.delayed(const Duration(milliseconds: 350));
         if (!mounted) return;
       
        context.go('/loan-redirect');
      } catch (refreshError) {
         if (!mounted) return;
        

        // Check if we're still on this screen
        if (!ModalRoute.of(context)!.isCurrent) {
          debugPrint("⚠️ User already navigated away, not showing error");
          return;
        }

        setState(() {
          _authMessage = 'Session expired. Please login with password';
          isLoading = false;
        });

        _showSnackBar(
          'Your session has expired. Please login again with your password',
          isError: true,
        );
      }
    } catch (e) {
       if (!mounted) return;
      debugPrint('Biometric auth error: $e');
      

      setState(() {
        _authMessage = 'Authentication error';
        isLoading = false;
      });

      _showSnackBar('Authentication failed: $e', isError: true);
    } finally {
       
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }


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
    if (!mounted) return;

    

    final data = result['data'];
    

    final tokenStorage = TokenStorage();
    
    // Check both possible field names
    final accessToken = data['accessToken'] ?? data['access_token'];
    final refreshToken = data['refreshToken'] ?? data['refresh_token'];
    
    debugPrint("🔑 Access token found: ${accessToken != null}");
    debugPrint("🔑 Refresh token found: ${refreshToken != null}");
    
    if (accessToken != null) {
      debugPrint("🔑 Access token preview: ${accessToken.toString().substring(0, 20)}...");
    }
    if (refreshToken != null) {
      debugPrint("🔑 Refresh token preview: ${refreshToken.toString().substring(0, 20)}...");
    }
    
    if (accessToken != null && refreshToken != null) {
      debugPrint("💾 Calling saveTokens...");
      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
       if (!mounted) return;
      debugPrint("✅ saveTokens completed");
    } else {
      debugPrint("❌ WARNING: Missing tokens in response!");
      if (accessToken == null) debugPrint("   - accessToken is NULL");
      if (refreshToken == null) debugPrint("   - refreshToken is NULL");
    }
    
    // Verify tokens immediately after saving
    debugPrint("🔍 Immediate verification:");
    final verifyAccess = await tokenStorage.getAccessToken();
     if (!mounted) return;
    final verifyRefresh = await tokenStorage.getRefreshToken();
     if (!mounted) return;
    debugPrint("   Access: ${verifyAccess != null}");
    debugPrint("   Refresh: ${verifyRefresh != null}");
    
    // Save other data
    await LocalStorage.saveUser(data['user']);
     if (!mounted) return;
    await LocalStorage.saveToken(accessToken);
     if (!mounted) return;
    await LocalStorage.setHasLoan(data['hasLoan']);
     if (!mounted) return;
    await LocalStorage.setHasLoginBefore(true);
    if (!mounted) return;

    String resultMessage = result["message"] ?? "Login successful";
    _showSnackBar(resultMessage, isError: false);
    context.go("/loan-redirect");
  } catch (e) {
    if (!mounted) return;
    if (mounted) {
      _showSnackBar(e.toString(), isError: true);
    }
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

  String _normalizePhoneNumber(String input) {
    String phone = input.replaceAll(RegExp(r'\s+'), '');

    if (phone.startsWith('+234')) {
      return phone;
    } else if (phone.startsWith('234')) {
      return phone;
    } else if (phone.startsWith('0')) {
      return '234${phone.substring(1)}';
    } else {
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
                            context.push('/forgot-password-screen');
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

                // Only show biometric button if conditions are met
                if (_biometricAvailable) ...[
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
                  Opacity(
                    opacity: _canUseBiometric ? 1.0 : 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        width: 342,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _canUseBiometric && !isLoading
                                  ? _authenticateWithFingerprint
                                  : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:
                                    _canUseBiometric
                                        ? [Color(0xffE5E7EB), Color(0xffA198FF)]
                                        : [
                                          Colors.grey.shade300,
                                          Colors.grey.shade400,
                                        ],
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
                                    color:
                                        _canUseBiometric
                                            ? null
                                            : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Use Biometric Login",
                                    style: TextStyle(
                                      color:
                                          _canUseBiometric
                                              ? Colors.white
                                              : Colors.grey.shade600,
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
                  ),
                  if (!_canUseBiometric)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _authMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                ],

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
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signUp');
                          },
                          child: Text(
                            "Create an Account",
                            style: TextStyle(
                              fontSize: 12,
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
