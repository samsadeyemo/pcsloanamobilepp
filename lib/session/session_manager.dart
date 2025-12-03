import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pcsloan/main.dart'; // imports rootNavigatorKey
import 'package:go_router/go_router.dart';

class SessionManager with WidgetsBindingObserver {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  final _storage = const FlutterSecureStorage();
  Timer? _timer;
  final Duration timeout = const Duration(minutes: 5);

  SessionManager._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeout, _logoutUser);
  }

  void onUserActivity() => _resetTimer();

  void _logoutUser() async {
    await _storage.deleteAll();

    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      GoRouter.of(ctx).go('/signIn'); // logout route
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onUserActivity();
    }
  }
}
