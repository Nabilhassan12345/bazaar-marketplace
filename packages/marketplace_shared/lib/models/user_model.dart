import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/enums/user_role.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.isBlocked,
    required this.listingCount,
    required this.approvedListingCount,
    required this.emailVerified,
    required this.phoneVerified,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.photoUrl,
    this.cityId,
    this.bio,
    this.blockedAt,
    this.blockedReason,
    this.preferredLanguage,
    this.notificationSettings = const {},
    this.lastActiveAt,
  });

  final String id;
  final String email;
  final String? phone;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final String? cityId;
  final String? bio;
  final bool isBlocked;
  final DateTime? blockedAt;
  final String? blockedReason;
  final int listingCount;
  final int approvedListingCount;
  final bool emailVerified;
  final bool phoneVerified;
  final String? preferredLanguage;
  final Map<String, dynamic> notificationSettings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel.fromMap(doc.id, data);
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String?,
      displayName: data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      role: UserRole.fromValue(data['role'] as String? ?? 'user'),
      cityId: data['cityId'] as String?,
      bio: data['bio'] as String?,
      isBlocked: data['isBlocked'] as bool? ?? false,
      blockedAt: _timestampToDateTime(data['blockedAt']),
      blockedReason: data['blockedReason'] as String?,
      listingCount: data['listingCount'] as int? ?? 0,
      approvedListingCount: data['approvedListingCount'] as int? ?? 0,
      emailVerified: data['emailVerified'] as bool? ?? false,
      phoneVerified: data['phoneVerified'] as bool? ?? false,
      preferredLanguage: data['preferredLanguage'] as String?,
      notificationSettings: Map<String, dynamic>.from(
        data['notificationSettings'] as Map? ?? {},
      ),
      createdAt: _timestampToDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _timestampToDateTime(data['updatedAt']) ?? DateTime.now(),
      lastActiveAt: _timestampToDateTime(data['lastActiveAt']),
    );
  }

  factory UserModel.newUser({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
    bool emailVerified = false,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      role: UserRole.user,
      isBlocked: false,
      listingCount: 0,
      approvedListingCount: 0,
      emailVerified: emailVerified,
      phoneVerified: false,
      preferredLanguage: 'fr',
      notificationSettings: const {
        'listingApproved': true,
        'listingRejected': true,
      },
      createdAt: now,
      updatedAt: now,
      lastActiveAt: now,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      if (phone != null) 'phone': phone,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.value,
      if (cityId != null) 'cityId': cityId,
      'bio': bio ?? '',
      'isBlocked': isBlocked,
      'blockedAt': blockedAt != null ? Timestamp.fromDate(blockedAt!) : null,
      'blockedReason': blockedReason,
      'listingCount': listingCount,
      'approvedListingCount': approvedListingCount,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
      'notificationSettings': notificationSettings,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (lastActiveAt != null)
        'lastActiveAt': Timestamp.fromDate(lastActiveAt!),
    };
  }

  static DateTime? _timestampToDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
