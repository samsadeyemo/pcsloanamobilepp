import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/auth/presentation/screens/account_created_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/create_password.dart';
import 'package:pcsloan/features/auth/presentation/screens/get_started_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/login_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/transaction_pin_screen.dart';
import 'package:pcsloan/features/auth/presentation/screens/verify_phone_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/active_loan_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/loan_redirect_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/no_loan_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/apply_for_loan.dart';
import 'package:pcsloan/features/loan_application/presentation/bvn_verification_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/debit_authorization.dart';
import 'package:pcsloan/features/loan_application/presentation/facial_verification_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_status_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_summary.dart';
import 'package:pcsloan/features/password_management/presentation/forget_password_screen.dart';
import 'package:pcsloan/features/password_management/presentation/password_changed_success_screen.dart';
import 'package:pcsloan/features/password_management/presentation/verify_otp_screen.dart';
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

    ),
    GoRoute(
      path: '/verify-password-otp',
      builder: (context, state) => const VerifyOtpScreen()
    ),
    GoRoute(
      path: '/password-change-success',
      builder: (context, state) => const PasswordChangedSuccessScreen()
      ),
    GoRoute(
      path: '/loan-redirect',
      builder: (context, state) => const LoanRedirectScreen()
      ),
    GoRoute(
      path: '/active-loan',
      builder: (context, state) => const ActiveLoanScreen(),
    ),
    GoRoute(
      path: '/no-loan',
      builder: (context, state) => const NoLoanScreen(),
    ),
    GoRoute(
      path: '/loan_application',
      builder:(context, state) => const ApplyForLoan(),
    ),
    GoRoute(
      path: '/Loan-status-screen',
      builder: (context, state) => const LoanStatusScreen(),
      ),
      GoRoute(
        path: '/loan-summary',
        builder: (context, state) => const LoanSummary(),
        ),
      GoRoute(
        path: '/bvn-verification-screen',
        builder: (context, state) => const BvnVerificationScreen(),
        ),
      GoRoute(
        path: '/facial-verification-screen',
        builder: (context, state) => const FacialVerificationScreen(),
        ),
      GoRoute(
        path: '/debit-authorization-screen',
        builder: (context, state) => const DebitAuthorizationScreen(),
        )  
      


  ],
);
