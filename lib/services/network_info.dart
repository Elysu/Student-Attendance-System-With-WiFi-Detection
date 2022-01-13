import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetInfo {
  NetworkInfo networkInfo = NetworkInfo();

  getBSSID(BuildContext context) async {
    if (Platform.isIOS) { // IOS
      LocationAuthorizationStatus status = await networkInfo.getLocationServiceAuthorization();

      if (status == LocationAuthorizationStatus.notDetermined) {
        status = await networkInfo.requestLocationServiceAuthorization();
      }

      if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
        var wifiBSSID = await networkInfo.getWifiBSSID();
        return wifiBSSID;
      } else {
        print('Location service is not authorized, the data might not be correct');
        var wifiBSSID = await networkInfo.getWifiBSSID();
        return wifiBSSID;
      }
    } else if (Platform.isAndroid) { // ANDROID
      var status = await Permission.locationWhenInUse.status;

      if (status.isGranted) {
        var wifiBSSID = await networkInfo.getWifiBSSID();
        return wifiBSSID;
      } else {
        var request = await Permission.locationWhenInUse.request();
        print(request);

        if (request.isGranted) {
          var wifiBSSID = await networkInfo.getWifiBSSID();
          return wifiBSSID;
        } else if (request.isPermanentlyDenied) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Permission permanently denied."),
                content: const Text("For verification purposes, you can only take attendance if location permission is granted. You need to manually grant the permission in the settings due to it being permanently denied."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL")
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                    child: const Text("OPEN APP SETTINGS")
                  )
                ],
              );
            }
          );
          return "permanently-denied";
        } else if (request.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              "For verification purposes, you can only take attendance if location permission is granted.",
            ),
          ));
          return "denied";
        }
      }
    }
  }
}