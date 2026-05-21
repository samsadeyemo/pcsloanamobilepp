// import 'dart:async';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/widgets.dart';

// class NetworkService {
//   final _connectivity = Connectivity();

//  Stream<bool> get onNetworkChange async* {
//   yield await _hasConnection();
//   await for (final _ in _connectivity.onConnectivityChanged) {
//     await Future.delayed(const Duration(milliseconds: 300));
//     yield await _hasConnection();
//   }
// }

//   Future<bool> _hasConnection() async {
//   final result = await _connectivity.checkConnectivity();
//   if (result == ConnectivityResult.none) return false;

//   try {
//     final socket = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 3));
//     socket.destroy();
//     return true;
//   } catch (e) {
//     debugPrint('Network check failed: $e');
//     return false;
//   }
// }


// }


import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class NetworkService {
  final _connectivity = Connectivity();

  Stream<bool> get onNetworkChange async* {
    // Small delay on startup so the network interface wakes up first
    await Future.delayed(const Duration(seconds: 1));
    yield await _hasConnectionWithRetry();

    await for (final _ in _connectivity.onConnectivityChanged) {
      // Give the network stack time to fully reconnect
      await Future.delayed(const Duration(seconds: 2));
      yield await _hasConnectionWithRetry();
    }
  }

  // Retries up to 3 times before declaring offline
  Future<bool> _hasConnectionWithRetry({int retries = 3}) async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    for (int i = 0; i < retries; i++) {
      final connected = await _hasConnection();
      if (connected) return true;
      if (i < retries - 1) {
        await Future.delayed(Duration(seconds: i + 1)); // 1s, 2s backoff
      }
    }
    return false;
  }

  Future<bool> _hasConnection() async {
    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (e) {
      debugPrint('Network check failed: $e');
      return false;
    }
  }
}