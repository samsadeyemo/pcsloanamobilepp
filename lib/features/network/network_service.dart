import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final _connectivity = Connectivity();

  Stream<bool> get onNetworkChange async* {
    yield await _hasConnection(); // initial state
    yield* _connectivity.onConnectivityChanged.asyncMap(
      (_) => _hasConnection(),
    );
  }

  Future<bool> _hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    // 🔥 Extra step: actually try to connect to internet
    try {
      final lookup = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
