import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/constants/business_types.dart';

class BusinessListing {
  const BusinessListing({
    required this.id,
    required this.companyName,
    required this.businessTypeCode,
    required this.location,
    required this.contactName,
    required this.createdAt,
    this.contactPhone,
    this.contactEmail,
    this.photoUrl,
    this.remarks,
    this.hidden = false,
  });

  final String id;
  final String companyName;
  final String businessTypeCode;
  final String location;
  final String contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? photoUrl;
  final String? remarks;
  final DateTime createdAt;
  final bool hidden;

  BusinessType? get businessType => BusinessTypes.byCode(businessTypeCode);

  String get businessTypeLabel =>
      businessType?.label ?? businessTypeCode;

  bool get hasContact =>
      (contactPhone != null && contactPhone!.trim().isNotEmpty) ||
      (contactEmail != null && contactEmail!.trim().isNotEmpty);

  bool isVisibleInCurrentWindow(DateTime now) =>
      !hidden &&
      now.difference(createdAt) <= AppConfig.currentListingsWindow;

  bool isVisibleInTypeWindow(DateTime now) =>
      !hidden &&
      now.difference(createdAt) <= AppConfig.typeListingsWindow;

  BusinessListing copyWith({
    String? id,
    String? companyName,
    String? businessTypeCode,
    String? location,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? photoUrl,
    String? remarks,
    DateTime? createdAt,
    bool? hidden,
  }) {
    return BusinessListing(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      businessTypeCode: businessTypeCode ?? this.businessTypeCode,
      location: location ?? this.location,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      photoUrl: photoUrl ?? this.photoUrl,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      hidden: hidden ?? this.hidden,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'businessTypeCode': businessTypeCode,
      'location': location,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'photoUrl': photoUrl,
      'remarks': remarks,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'hidden': hidden,
    };
  }

  factory BusinessListing.fromMap(String id, Map<String, dynamic> map) {
    final createdRaw = map['createdAt'];
    final DateTime createdAt;
    if (createdRaw is DateTime) {
      createdAt = createdRaw;
    } else if (createdRaw is String) {
      createdAt = DateTime.parse(createdRaw);
    } else {
      createdAt = DateTime.now().toUtc();
    }

    return BusinessListing(
      id: id,
      companyName: (map['companyName'] ?? '') as String,
      businessTypeCode: (map['businessTypeCode'] ?? '') as String,
      location: (map['location'] ?? '') as String,
      contactName: (map['contactName'] ?? '') as String,
      contactPhone: map['contactPhone'] as String?,
      contactEmail: map['contactEmail'] as String?,
      photoUrl: map['photoUrl'] as String?,
      remarks: map['remarks'] as String?,
      createdAt: createdAt.toLocal(),
      hidden: (map['hidden'] ?? false) as bool,
    );
  }
}

class ListingDraft {
  String companyName = '';
  BusinessType? businessType;
  String location = '';
  String contactName = '';
  String contactPhone = '';
  String contactEmail = '';
  String remarks = '';
  String? localPhotoPath;
  List<int>? localPhotoBytes;

  /// Returns null when valid; otherwise an error message.
  String? validate() {
    if (companyName.trim().isEmpty) {
      return 'Company name is required.';
    }
    if (businessType == null) {
      return 'Please select a business type.';
    }
    if (location.trim().isEmpty) {
      return 'Location is required.';
    }
    if (contactName.trim().isEmpty) {
      return 'Contact name is required.';
    }
    final phone = contactPhone.trim();
    final email = contactEmail.trim();
    if (phone.isEmpty && email.isEmpty) {
      return 'Enter a mobile number or email (at least one).';
    }
    if (email.isNotEmpty && !_looksLikeEmail(email)) {
      return 'Enter a valid email address.';
    }
    if (localPhotoBytes != null &&
        localPhotoBytes!.length > AppConfig.maxPhotoBytes) {
      return 'Photo must be under 500 KB.';
    }
    return null;
  }

  static bool _looksLikeEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }
}
