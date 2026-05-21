// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'network_providers.dart';

// class NetworkGuard extends ConsumerWidget {
//   final Widget child;
//   const NetworkGuard({super.key, required this.child});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final status = ref.watch(networkStatusProvider);

//     return status.when(
//   data: (isOnline) {
//     debugPrint("📶 NetworkGuard: isOnline = $isOnline");
//     if (isOnline) {
//       return child;
//     } else {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.wifi_off, size: 60, color: Colors.red),
//               SizedBox(height: 20),
//               Text("No internet connection",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Text("Please check your connection"),
//             ],
//           ),
//         ),
//       );
//     }
//   },
//   loading: () => const Scaffold(
//     body: Center(child: CircularProgressIndicator()),
//   ),
//   error: (_, __) => const Scaffold(
//     body: Center(child: Text("Error checking network")),
//   ),
// );

//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_providers.dart';

class NetworkGuard extends ConsumerWidget {
  final Widget child;
  const NetworkGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(networkStatusProvider);

    return status.when(
      // While the first check is running, just show the child
      // Don't block the UI with a spinner on every app start
      loading: () => child,
      data: (isOnline) {
        debugPrint("📶 NetworkGuard: isOnline = $isOnline");
        if (isOnline) return child;
        return _NoInternetScreen(
          onRetry: () => ref.invalidate(networkStatusProvider),
        );
      },
      error: (_, __) => _NoInternetScreen(
        onRetry: () => ref.invalidate(networkStatusProvider),
      ),
    );
  }
}

class _NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;
  const _NoInternetScreen({required this.onRetry});

  @override
  State<_NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<_NoInternetScreen> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    setState(() => _isRetrying = true);
    widget.onRetry();
    // Give the stream a moment to emit before re-enabling the button
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please check your connection and try again.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _isRetrying ? null : _handleRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7C70DF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: _isRetrying
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(_isRetrying ? 'Checking...' : 'Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}