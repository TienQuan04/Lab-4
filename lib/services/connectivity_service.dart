import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
class ConnectivityService {
  final Connectivity connectivity = Connectivity();
  final StreamController<bool> connectionController =
      StreamController<bool>.broadcast();
  ConnectivityService() {
    connectivity.onConnectivityChanged.listen((result) {
      final hasConnection = result != ConnectivityResult.none;
      connectionController.add(hasConnection);
    });
  }
  Stream<bool> get connectionStatusStream => connectionController.stream;
  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    connectionController.close();
  }
}
