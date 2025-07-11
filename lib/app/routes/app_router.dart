import 'package:go_router/go_router.dart';
import 'package:pcsloan/features/auth/presentation/screens/get_started_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) =>  OnboardingScreen()),
      GoRoute(path: '/getStartedScreen', builder: (_, _) => GetStartedScreen()),
      // GoRoute(path: "/signIn", builder: (_, _) => SignInScreen()),
      // GoRoute(path: "/signUp", builder: (_, _) => SignUpScreen()),
  ],
  );
