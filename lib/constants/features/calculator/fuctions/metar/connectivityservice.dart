import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((results) => _hasConnection(results));

  Future<bool> checkInitialConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }
}
