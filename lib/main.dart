import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcsloan/api/api_client.dart';
import 'package:pcsloan/auth_storage/token_storage.dart';
import 'package:pcsloan/config/app_config.dart';
import 'package:pcsloan/config/app_config_provider.dart';
import 'package:pcsloan/features/network/network_guard.dart';
import 'package:pcsloan/session/session_manager.dart';
import 'app/routes/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final tokenStorage = TokenStorage();
late final ApiClient apiClient;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to load .env, but don't fail if it doesn't exist
  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env file loaded successfully");
  } catch (e) {
    print("⚠️ .env file not found, using dart-define values");
    // Initialize dotenv with empty map so dotenv.env doesn't throw errors
    dotenv.testLoad(fileInput: '');
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  SessionManager().init();
  final config = AppConfig.fromEnv();

  apiClient = ApiClient(
    appConfig: config,
    tokenStorage: tokenStorage,
    onAuthenticationFailed: () {
      router.go('/signin'); // ✅ use your GoRouter instance directly
    },
  );

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.read(appConfigProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: config.env.toUpperCase() != 'PROD',
      routerConfig: router,
      theme: ThemeData(fontFamily: 'Inter'),
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          // onPointerDown catches the very start of any touch (scroll, tap, drag)
          onPointerDown: (_) => SessionManager().onUserActivity(),
          child: NetworkGuard(child: child ?? const SizedBox()),
        );
      },
    );
  }
}
