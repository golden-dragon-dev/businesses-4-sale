import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:uuid/uuid.dart';

/// Firestore + Storage implementation (used when Firebase is configured).
class FirebaseListingRepository implements ListingRepository {
  FirebaseListingRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _listings =>
      _firestore.collection('listings');

  @override
  Stream<List<BusinessListing>> watchAll() {
    return _listings
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Future<List<BusinessListing>> fetchAll() async {
    final snapshot =
        await _listings.orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => _fromFirestore(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<BusinessListing?> getById(String id) async {
    final doc = await _listings.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return _fromFirestore(doc.id, doc.data()!);
  }

  @override
  Future<BusinessListing> create({
    required ListingDraft draft,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    final error = draft.validate();
    if (error != null) {
      throw ArgumentError(error);
    }

    final id = _uuid.v4();
    String? photoUrl;

    if (photoBytes != null && photoBytes.isNotEmpty) {
      final name = photoFileName ?? '$id.jpg';
      final ref = _storage.ref().child('listings/$id/$name');
      await ref.putData(
        photoBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      photoUrl = await ref.getDownloadURL();
    }

    final listing = BusinessListing(
      id: id,
      companyName: draft.companyName.trim(),
      businessTypeCode: draft.businessType!.code,
      location: draft.location.trim(),
      contactName: draft.contactName.trim(),
      contactPhone: draft.contactPhone.trim().isEmpty
          ? null
          : draft.contactPhone.trim(),
      contactEmail: draft.contactEmail.trim().isEmpty
          ? null
          : draft.contactEmail.trim(),
      photoUrl: photoUrl,
      remarks: draft.remarks.trim().isEmpty ? null : draft.remarks.trim(),
      createdAt: DateTime.now(),
    );

    await _listings.doc(id).set({
      ...listing.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return listing;
  }

  BusinessListing _fromFirestore(String id, Map<String, dynamic> data) {
    final createdRaw = data['createdAt'];
    DateTime createdAt;
    if (createdRaw is Timestamp) {
      createdAt = createdRaw.toDate();
    } else if (createdRaw is String) {
      createdAt = DateTime.parse(createdRaw);
    } else if (createdRaw is DateTime) {
      createdAt = createdRaw;
    } else {
      createdAt = DateTime.now();
    }

    return BusinessListing(
      id: id,
      companyName: (data['companyName'] ?? '') as String,
      businessTypeCode: (data['businessTypeCode'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      contactName: (data['contactName'] ?? '') as String,
      contactPhone: data['contactPhone'] as String?,
      contactEmail: data['contactEmail'] as String?,
      photoUrl: data['photoUrl'] as String?,
      remarks: data['remarks'] as String?,
      createdAt: createdAt,
      hidden: (data['hidden'] ?? false) as bool,
    );
  }
}
