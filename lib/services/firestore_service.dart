import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/pickup_request.dart';

class FirestoreService {
  FirestoreService(this._db);

  final FirebaseFirestore _db;

  Stream<AppUser?> streamUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDocument(doc);
    });
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDocument(doc);
  }

  Future<void> saveUser(AppUser user, {String? vehicleSize}) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
    if (user.role == 'collector') {
      await _db.collection('collectors').doc(user.uid).set({
        'uid': user.uid,
        'vehicle_size': vehicleSize,
        'is_available': true,
      });
    }
  }

  Future<void> createPickupRequest({
    required String generatorId,
    required String generatorType,
    required String wasteType,
    required double latitude,
    required double longitude,
    String? directionsLandmarks,
  }) async {
    final doc = _db.collection('requests').doc();
    await doc.set({
      'request_id': doc.id,
      'generator_id': generatorId,
      'generator_type': generatorType,
      'waste_type': wasteType,
      'latitude': latitude,
      'longitude': longitude,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
      if (directionsLandmarks != null && directionsLandmarks.trim().isNotEmpty)
        'directions_landmarks': directionsLandmarks.trim(),
    });
  }

  Stream<List<PickupRequest>> streamRequests() {
    return _db
        .collection('requests')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PickupRequest.fromDocument).toList());
  }

  Future<void> claimRequest({required String requestId, required String collectorId}) async {
    await _db.collection('requests').doc(requestId).update({
      'status': 'claimed',
      'collector_id': collectorId,
    });
  }

  Future<void> completeRequest(String requestId) async {
    await _db.collection('requests').doc(requestId).update({'status': 'completed'});
  }
}
