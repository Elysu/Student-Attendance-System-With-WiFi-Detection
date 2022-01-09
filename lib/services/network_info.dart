import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetInfo {
  NetworkInfo networkInfo = NetworkInfo();

  getBSSID() async {
    var wifiBSSID, wifiName;

    if (Platform.isIOS) { // IOS
      LocationAuthorizationStatus status = await networkInfo.getLocationServiceAuthorization();

      if (status == LocationAuthorizationStatus.notDetermined) {
        status = await networkInfo.requestLocationServiceAuthorization();
      }

      if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
        wifiBSSID = await networkInfo.getWifiBSSID();
      } else {
        print('Location service is not authorized, the data might not be correct');
        wifiBSSID = await networkInfo.getWifiBSSID();
      }
    } else if (Platform.isAndroid) { // ANDROID
      var status = await Permission.locationWhenInUse.status;
      print(status);

      if (await Permission.locationWhenInUse.request().isPermanentlyDenied) {
        openAppSettings();
      } else if (await Permission.locationWhenInUse.request().isGranted) {
        print("granted");

        if (await Permission.locationWhenInUse.isGranted) {
          wifiBSSID = await networkInfo.getWifiBSSID();
          wifiName = await networkInfo.getWifiName();
          print(wifiBSSID);
          print(wifiName);
        }
      }
    }
  }
}