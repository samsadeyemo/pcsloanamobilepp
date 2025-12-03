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
  await dotenv.load(fileName: ".env");
  final sharedPreferences = await SharedPreferences.getInstance();

   SessionManager().init(); 
   apiClient = ApiClient(
    appConfig: appConfig, // This uses the appConfig from app_config.dart
    tokenStorage: tokenStorage,
    onAuthenticationFailed: () {
      rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/signIn',
        (route) => false,
      );
    },
  );
  runApp(
    ProviderScope(
     
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
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => SessionManager().onUserActivity(),
          child: NetworkGuard(child: child ?? const SizedBox()),
        );
      },
    );
  }
}
