import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pcsloan/main.dart'; // imports rootNavigatorKey
import 'package:go_router/go_router.dart';

class SessionManager with WidgetsBindingObserver {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

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
  print("⏰ Session timeout - navigating to login");
  
  // DON'T clear tokens - let biometric work!
  // Tokens will be validated when user tries to use them
  
  final ctx = rootNavigatorKey.currentContext;
  if (ctx != null) {
    GoRouter.of(ctx).go('/signIn');
  }
}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onUserActivity();
    }
  }
}
