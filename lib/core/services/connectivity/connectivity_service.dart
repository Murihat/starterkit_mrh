import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onStatusChanged => _connectivity.onConnectivityChanged.map(
    (results) =>
        results.isNotEmpty && !results.contains(ConnectivityResult.none),
  );

  Future<bool> getCurrentStatus() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}
