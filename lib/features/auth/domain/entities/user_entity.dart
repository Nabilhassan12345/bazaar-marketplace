import 'package:marketplace_shared/marketplace_shared.dart';

class UserEntity {
  const UserEntity({
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
    this.phone,
    this.photoUrl,
    this.cityId,
    this.bio,
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
  final int listingCount;
  final int approvedListingCount;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      phone: model.phone,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      role: model.role,
      cityId: model.cityId,
      bio: model.bio,
      isBlocked: model.isBlocked,
      listingCount: model.listingCount,
      approvedListingCount: model.approvedListingCount,
      emailVerified: model.emailVerified,
      phoneVerified: model.phoneVerified,
      createdAt: model.createdAt,
    );
  }
}
