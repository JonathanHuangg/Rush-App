import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

// meant to create the user
class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(String uid, String name, String fraternity, String phrase, bool isRushChair) async {

    // accesses the 'users' collection in firestore
    // creates or accesses within this collection defined by deviceId
    // set data of document with name, fraternity and timestamp
    await _firestore.collection('users').doc(uid).set({
      'name' : name, 
      'fraternity' : fraternity,
      'createdAt' : FieldValue.serverTimestamp(),
      'phrase' : phrase,
      'isRushChair' : isRushChair,
      'authorized' : false // signifying if the user is allowed into the fraternity
    });
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // doesn't work on emulators
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

  
}