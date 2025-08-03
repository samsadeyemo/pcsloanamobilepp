import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String phoneNumber = '';
  String password = "";

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0F2D62),
                          fontFamily: "Inter",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '+234',
                              style: TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) => phoneNumber = value,
                                validator:
                                    (value) =>
                                        value != null && value.length >= 10
                                            ? null
                                            : "Phone number must be 10 Digits",

                                decoration: InputDecoration(
                                  hintText: 'Enter your phone number',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFADAEBC),
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0F2D62),
                          fontFamily: "Inter",
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                validator:
                                    (value) =>
                                        value != null && value.length >= 6
                                            ? null
                                            : "Password too short try again",
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
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
                authState.isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
                      padding: const EdgeInsets.only(top: 0, right: 0),
                      child: SizedBox(
                        width: 342,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // await ref
                              //     .read(authProvider.notifier)
                              //     .login(phoneNumber.trim(), password.trim());

                              // final newState = ref.read(authProvider);
                              // if (newState.token != null) {
                              //   context.go("/homepage"); // navigate after login
                              // } else if (newState.error != null) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text(newState.error!)),
                              //   );
                              // }

                              context.go("/homepage");
                            }
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
                      onPressed: () {
                        // handle biometric login
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
