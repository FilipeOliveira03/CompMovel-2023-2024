import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {

  Future<bool> isOnline() async {
    final conectivity = await Connectivity().checkConnectivity();
    return conectivity == ConnectivityResult.mobile || conectivity == ConnectivityResult.wifi;
  }
}