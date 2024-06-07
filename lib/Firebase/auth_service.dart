import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;


// Returns the unique id for every device
// goal is to use it as a way of identification for sign in
Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  } else {
    return null;
  }
}