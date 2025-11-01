import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class NetworkService {
  final _connectivity = Connectivity();

 Stream<bool> get onNetworkChange async* {
  yield await _hasConnection();
  await for (final _ in _connectivity.onConnectivityChanged) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield await _hasConnection();
  }
}


  // Future<bool> _hasConnection() async {
  //   final result = await _connectivity.checkConnectivity();
  //   if (result == ConnectivityResult.none) return false;

  //   // 🔥 Extra step: actually try to connect to internet
  //   try {
  //     final lookup = await InternetAddress.lookup('google.com')
  //         .timeout(const Duration(seconds: 3));
  //     return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  Future<bool> _hasConnection() async {
  final result = await _connectivity.checkConnectivity();
  if (result == ConnectivityResult.none) return false;

  try {
    final socket = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 3));
    socket.destroy();
    return true;
  } catch (e) {
    debugPrint('Network check failed: $e');
    return false;
  }
}


}
