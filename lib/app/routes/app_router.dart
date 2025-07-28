import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/auth/presentation/screens/account_created_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/create_password.dart';
import 'package:pcsloan/features/auth/presentation/screens/get_started_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/login_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/transaction_pin_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/verify_phone_screen.dart';
import 'package:pcsloan/features/password_management/presentation/forget_password_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen()
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/getStartedScreen',
      builder: (context, state) => GetStartedScreen(),
    ),
    GoRoute(
      path: "/signIn",
      builder: (context, state) => LoginScreen()
    ),
    GoRoute(
      path: "/signUp",
      builder: (context, state) => SignUpScreen()
    ),
      GoRoute(
      path: '/create-password',
      builder: (context, state) => const CreatePasswordScreen(),
    ),
    GoRoute(
      path: '/verify-phone',
      builder: (context, state) => const VerifyPhoneScreen(),
    ),
    GoRoute(
      path: '/transaction-screen',
      builder: (context, state) => const TransactionPinScreen(),
    ),
    GoRoute(
      path: '/account-created-screen',
      builder: (context, state) => const AccountCreatedScreen(),
    ),
    GoRoute(
      path: '/forgot-password-screen',
      builder: (context, state) => const ForgetPasswordScreen(),
      )
  ],
);
