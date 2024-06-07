import 'package:cloud_firestore/cloud_firestore.dart';

// meant to create the user
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> createUser(String deviceId, String name, String fraternity) async {

    // accesses the 'users' collection in firestore
    // creates or accesses within this collection defined by deviceId
    // set data of document with name, fraternity and timestamp
    await _firestore.collection('users').doc(deviceId).set({
      'name' : name, 
      'fraternity' : fraternity,
      'createdAt' : FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUser(String deviceId) async {
    return await _firestore.collection('users').doc(deviceId).get();
  }
}