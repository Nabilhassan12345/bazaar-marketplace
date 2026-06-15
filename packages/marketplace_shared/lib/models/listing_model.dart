import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/enums/listing_category.dart';
import 'package:marketplace_shared/enums/listing_status.dart';
import 'package:marketplace_shared/utils/search_tokens.dart';

class ListingModel {
  const ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.city,
    required this.images,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhoto,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.viewCount,
    required this.isFeatured,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final ListingCategory category;
  final String city;
  final List<String> images;
  final String ownerId;
  final String ownerName;
  final String? ownerPhoto;
  final ListingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final bool isFeatured;

  factory ListingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ListingModel.fromMap(doc.id, data);
  }

  factory ListingModel.fromMap(String id, Map<String, dynamic> data) {
    return ListingModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      category: ListingCategory.fromValue(data['category'] as String? ?? ''),
      city: data['city'] as String? ?? '',
      images: List<String>.from(data['images'] as List? ?? []),
      ownerId: data['ownerId'] as String? ?? data['sellerId'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? '',
      ownerPhoto: data['ownerPhoto'] as String?,
      status: ListingStatus.fromValue(data['status'] as String? ?? 'draft'),
      createdAt: _toDateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _toDateTime(data['updatedAt']) ?? DateTime.now(),
      viewCount: data['viewCount'] as int? ?? 0,
      isFeatured: data['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category.value,
      'city': city,
      'images': images,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhoto': ownerPhoto,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'viewCount': viewCount,
      'isFeatured': isFeatured,
      'searchTokens': generateSearchTokens(
        title: title,
        description: description,
      ),
      // Required by Firestore security rules.
      'sellerId': ownerId,
      'isDeleted': false,
      'favoriteCount': 0,
    };
  }

  ListingModel copyWith({
    String? title,
    String? description,
    double? price,
    ListingCategory? category,
    String? city,
    List<String>? images,
    ListingStatus? status,
    DateTime? updatedAt,
  }) {
    return ListingModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      city: city ?? this.city,
      images: images ?? this.images,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerPhoto: ownerPhoto,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount,
      isFeatured: isFeatured,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
