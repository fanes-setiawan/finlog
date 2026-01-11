import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository(this._firestore);

  // CREATE
  Future<void> add<T>({
    required String collectionPath,
    required T item,
    required Map<String, dynamic> Function(T) toJson,
    String? id, // Optional custom ID
  }) async {
    final ref = _firestore.collection(collectionPath);
    if (id != null) {
      await ref.doc(id).set(toJson(item));
    } else {
      await ref.add(toJson(item));
    }
  }

  // SET (Upsert)
  Future<void> set<T>({
    required String collectionPath,
    required String id,
    required T item,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    final data = toJson(item);
    if (data.containsKey('id')) data.remove('id');
    await _firestore
        .collection(collectionPath)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }

  // Helper to sanitize data (convert Timestamp to String)
  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _sanitizeData(value));
      } else if (value is List) {
        return MapEntry(
            key,
            value.map((e) {
              if (e is Timestamp) {
                return e.toDate().toIso8601String();
              } else if (e is Map<String, dynamic>) {
                return _sanitizeData(e);
              }
              return e;
            }).toList());
      }
      return MapEntry(key, value);
    });
  }

  // READ (Stream List)
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic>, String id) fromJson,
    Query<T> Function(Query<T> query)? queryBuilder,
  }) {
    // using withConverter locally
    var ref = _firestore.collection(collectionPath).withConverter<T>(
          fromFirestore: (snapshot, _) {
            var data = snapshot.data()!;
            data = _sanitizeData(data); // Apply sanitization
            data['id'] = snapshot.id;
            return fromJson(data, snapshot.id);
          },
          toFirestore: (value, _) =>
              {}, // Read-only stream mostly, but required
        );

    Query<T> query = ref;
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // READ (Future List)
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic>, String id) fromJson,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      data = _sanitizeData(data); // Apply sanitization
      data['id'] = doc.id;
      return fromJson(data, doc.id);
    }).toList();
  }

  // READ (Single)
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String docId,
    required T Function(Map<String, dynamic>, String id) fromJson,
  }) async {
    final doc = await _firestore.collection(collectionPath).doc(docId).get();
    if (!doc.exists) return null;
    var data = doc.data()!;
    data = _sanitizeData(data); // Apply sanitization
    data['id'] = doc.id;
    return fromJson(data, doc.id);
  }

  // UPDATE
  Future<void> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionPath).doc(docId).update(data);
  }

  // DELETE
  Future<void> delete({
    required String collectionPath,
    required String docId,
  }) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }
}
