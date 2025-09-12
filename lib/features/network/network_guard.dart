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
  data: (isOnline) {
    debugPrint("📶 NetworkGuard: isOnline = $isOnline");
    if (isOnline) {
      return child;
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wifi_off, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text("No internet connection",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Please check your connection"),
            ],
          ),
        ),
      );
    }
  },
  loading: () => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  ),
  error: (_, __) => const Scaffold(
    body: Center(child: Text("Error checking network")),
  ),
);

  }
}
