import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/activity/presentation/activity_tab.dart';
import 'package:pcsloan/features/activity/presentation/recent_transactions_screen.dart';
import 'package:pcsloan/features/auth/screens/account_created_screen.dart';
import 'package:pcsloan/features/auth/screens/create_password.dart';
import 'package:pcsloan/features/auth/screens/get_started_screen.dart';
import 'package:pcsloan/features/auth/screens/login_screen.dart';
import 'package:pcsloan/features/auth/screens/sign_up_screen.dart';
import 'package:pcsloan/features/auth/screens/transaction_pin_screen.dart';
import 'package:pcsloan/features/auth/screens/verify_phone_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/active_loan_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/loan_redirect_screen.dart';
import 'package:pcsloan/features/dashboard/presentation/no_loan_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/apply_for_loan.dart';
import 'package:pcsloan/features/loan_application/presentation/bvn_verification_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/debit_authorization.dart';
import 'package:pcsloan/features/loan_application/presentation/facial_verification_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_disbursed_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_status_screen.dart';
import 'package:pcsloan/features/loan_application/presentation/loan_summary.dart';
import 'package:pcsloan/features/password_management/presentation/forget_password_screen.dart';
import 'package:pcsloan/features/password_management/presentation/password_changed_success_screen.dart';
import 'package:pcsloan/features/password_management/presentation/verify_otp_screen.dart';
import 'package:pcsloan/features/profile/presentation/change_pin_screen.dart';
import 'package:pcsloan/features/profile/presentation/change_password_screen.dart';
import 'package:pcsloan/features/profile/presentation/credentials_routing.dart';
import 'package:pcsloan/features/profile/presentation/notifications_screen.dart';
import 'package:pcsloan/features/profile/presentation/personal_information_screen.dart';
import 'package:pcsloan/features/profile/presentation/profile_screen.dart';
import 'package:pcsloan/features/profile/presentation/security_settings.dart';
import 'package:pcsloan/features/profile/presentation/support_screen.dart';
import 'package:pcsloan/main.dart';
import 'package:pcsloan/smile_id_test_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/getStartedScreen',
      builder: (context, state) => GetStartedScreen(),
    ),
    GoRoute(path: "/signIn", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/signUp", builder: (context, state) => SignUpScreen()),
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
      builder: (context, state) => const VerifyOtpScreen(),
    ),
    GoRoute(
      path: '/password-change-success',
      builder: (context, state) => const PasswordChangedSuccessScreen(),
    ),
    GoRoute(
      path: '/loan-redirect',
      builder: (context, state) => const LoanRedirectScreen(),
    ),
    GoRoute(
      path: '/active-loan',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return ActiveLoanScreen(dashData: data);
      },
    ),
    GoRoute(
      path: '/no-loan',
      builder: (context, state) => const NoLoanScreen(),
    ),
    GoRoute(
      path: '/loan_application',
      builder: (context, state) => const ApplyForLoan(),
    ),
    GoRoute(
      path: '/Loan-status-screen',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return LoanStatusScreen(loanData: data);
      },
    ),
    GoRoute(
      path: '/loan-summary',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return LoanSummary(loanData: data);
      },
      //  LoanSummary(),
    ),
    GoRoute(
      path: '/bvn-verification-screen',
      builder: (context, state) => const BvnVerificationScreen(),
    ),
    GoRoute(
      path: '/facial-verification-screen',
      builder: (context, state) => const SmileIDVerificationScreen(),
    ),
    GoRoute(
      path: '/debit-authorization-screen',
      builder: (context, state) => const DebitAuthorizationScreen(),
    ),
    GoRoute(
      path: '/loan-disbursed-screen',
      builder: (context, state) => const LoanDisbursedScreen(),
    ),
    GoRoute(
      path: '/activity-tab',
      builder: (context, state) => const ActivityTab(),
    ),
    GoRoute(
      path: '/user-profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: "/transactions-history",
      builder: (context, state) => RecentTransactionsPage(),),
    GoRoute(
      path: "/personal-information",
      builder: (context, state) => PersonalInformationScreen()
      ),
    GoRoute(
      path: "/security-settings",
      builder: (context, state) => SecuritySettings()
      ),
    GoRoute(
      path: '/notification-prefrence',
      builder: (context, state) => NotificationPreferences()
      ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordScreen()
      ),
    GoRoute(
      path: "/support-page",
      builder: (context,state) => SupportScreen()
    ),
    GoRoute(
      path: "/edit/credentials",
      builder: (contect, state) => EditCredentials()
      ),
    GoRoute(
      path: "/change-pin",
      builder: (content, state) => ChangePinScreen()
    ),
    GoRoute(
      path: "/smileid/verification",
      builder: (content, state) => SmileIDTestScreen()
      )
    
  ],
);
