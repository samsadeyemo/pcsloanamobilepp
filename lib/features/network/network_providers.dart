import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_service.dart';

final networkServiceProvider = Provider((ref) => NetworkService());

final networkStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.read(networkServiceProvider);
  return service.onNetworkChange;
});
