import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetInfo {
  NetworkInfo networkInfo = NetworkInfo();

  getBSSID() async {
    var status = await Permission.locationWhenInUse.status;
    var wifiBSSID, wifiName;

    print(status);

    if (status.isDenied) {
      // Use location.
      await Permission.locationWhenInUse.request();
    }

    if (await Permission.locationWhenInUse.isGranted) {
      wifiBSSID = await networkInfo.getWifiBSSID();
      wifiName = await networkInfo.getWifiName();
      print(wifiBSSID);
      print(wifiName);
    }
  }
}