// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  // Future<void> _init() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   final prefs = await SharedPreferences.getInstance();
  //   final seen = prefs.getBool('onboarding_done') ?? false;
  //   // final seenSignup = prefs.getBool('account_created') ?? false;
  //   // final accountVerified =  prefs.getBool('phone_verified') ?? false;
  //   final seenSignup = await LocalStorage.isAccountCreated();
  //   final accountVerified = await LocalStorage.isPhoneVerified();
  //   final passwordCreated = await LocalStorage.isPasswordCreated();
  //   final pinCreated = await LocalStorage.isPinCreated();

  //   if (seen & !seenSignup) {
  //     context.go('/getStartedScreen');
  //   } else if (seen & seenSignup & !accountVerified) {
  //     context.go('/verify-phone');
  //   } else if (seen & seenSignup & accountVerified & !passwordCreated) {
  //     context.go('/create-password');
  //   } else if (seen & seenSignup & accountVerified & passwordCreated & !pinCreated) {
  //     context.go('/transaction-screen');
  //   } else if (seen & seenSignup & accountVerified & passwordCreated & pinCreated) {
  //     context.go('/signIn');
  //   }
  //   else
  //     context.go('/onboarding');
  // }

   Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    final accountCreated = await LocalStorage.isAccountCreated();
    if (!mounted) return;
    final phoneVerified = await LocalStorage.isPhoneVerified();
    if (!mounted) return;
    final passwordCreated = await LocalStorage.isPasswordCreated();
    if (!mounted) return;
    final pinCreated = await LocalStorage.isPinCreated();
    if (!mounted) return;
    final hasLogin = await LocalStorage.hasLoginBefore();

    if (!mounted) return; // ✅ Always guard before navigation

    // 🧠 Navigation flow (clear and ordered)
    if (!onboardingDone) {
      context.go('/onboarding');
      return;
    }

    if (onboardingDone && !accountCreated) {
      context.go('/getStartedScreen');
      return;
    }

    if (accountCreated && !phoneVerified) {
      context.go('/verify-phone');
      return;
    }

    if (phoneVerified && !passwordCreated) {
      context.go('/create-password');
      return;
    }

    if (passwordCreated && !pinCreated) {
      context.go('/transaction-screen');
      return;
    }
    if (hasLogin){
          context.go('/signIn');

    }

    // ✅ All steps complete
    context.go('/signIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7C70DF), // Top color
              Color(0xFFA198FF), // Bottom color
              Color(0xFFA198FF),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                //first Circle
                Container(
                  width: 299,
                  height: 299,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),

                //second Circle
                Container(
                  width: 199,
                  height: 199,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),

                //third circle
                Container(
                  width: 99,
                  height: 99,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),

                //Center logo
                Positioned(
                  top: 120,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/icons/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fast, secure and hassle-free loans',
              style: TextStyle(
                color: Color(0xffFFFFFFB2).withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const CircularProgressIndicator(color: Color(0xFF00B7BD)),
          ],
        ),
      ),
    );
  }
}
