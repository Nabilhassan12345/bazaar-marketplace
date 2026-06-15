import 'package:cloud_firestore/cloud_firestore.dart';

class BlockModel {
  const BlockModel({
    required this.blockedUserId,
    required this.blockedAt,
    this.blockedDisplayName,
  });

  final String blockedUserId;
  final DateTime blockedAt;
  final String? blockedDisplayName;

  factory BlockModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return BlockModel.fromMap(doc.id, data);
  }

  factory BlockModel.fromMap(String blockedUserId, Map<String, dynamic> data) {
    return BlockModel(
      blockedUserId: blockedUserId,
      blockedAt: _toDateTime(data['blockedAt']) ?? DateTime.now(),
      blockedDisplayName: data['blockedDisplayName'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'blockedAt': Timestamp.fromDate(blockedAt),
      if (blockedDisplayName != null) 'blockedDisplayName': blockedDisplayName,
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
