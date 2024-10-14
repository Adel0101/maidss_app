import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> networkStatusController =
      StreamController<bool>.broadcast();

  // Keep track of the current network status
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void initialize() {
    // Initial check
    _checkCurrentConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _updateStatus(result);
    });
  }

  // Check current connectivity status
  Future<void> _checkCurrentConnectivity() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      _updateStatus(result);
    } catch (e) {
      print('Failed to get connectivity: $e');
    }
  }

  void _updateStatus(List<ConnectivityResult> result) {
    bool isConnected = result.first != ConnectivityResult.none;
    if (isConnected != _isOnline) {
      _isOnline = isConnected;
      networkStatusController.add(_isOnline);
    }
  }

  void dispose() {
    networkStatusController.close();
  }
}
