import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pcsloan/app/routes/app_router.dart';
import 'package:pcsloan/common/widgets/session_expired_dialog.dart';
import 'package:pcsloan/main.dart'; // imports rootNavigatorKey

class SessionManager with WidgetsBindingObserver {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  Timer? _timer;
  final Duration timeout = const Duration(minutes: 5);
  bool _promptShowing = false;

  // Screens where the user isn't logged in, so there's no session to expire.
  static const _publicRoutes = {
    '/',
    '/onboarding',
    '/getstartedscreen',
    '/signin',
    '/signup',
    '/verify-phone',
    '/create-password',
    '/transaction-screen',
    '/account-created-screen',
    '/forgot-password-screen',
    '/verify-password-otp',
    '/password-change-success',
  };

  SessionManager._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeout, () => showSessionExpired(
          message: "You've been inactive for 5 minutes. "
              'Please login again to continue.',
        ));
  }

  void onUserActivity() {
    if (!_promptShowing) _resetTimer();
  }

  bool get _onPublicRoute {
    final path =
        router.routerDelegate.currentConfiguration.uri.path.toLowerCase();
    return _publicRoutes.contains(path);
  }

  /// Shows the blocking "login again" prompt, then goes to the login screen.
  /// Tokens are kept on purpose so fingerprint login can refresh them.
  Future<void> showSessionExpired({
    String message = 'Your session has expired. Please login again.',
  }) async {
    if (_promptShowing || _onPublicRoute) return;
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;

    _promptShowing = true;
    _timer?.cancel();
    await SessionExpiredDialog.show(ctx, message: message);
    _promptShowing = false;

    router.go('/signIn');
    _resetTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Idle time only counts while the app is open in the foreground.
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      onUserActivity();
    }
  }
}
