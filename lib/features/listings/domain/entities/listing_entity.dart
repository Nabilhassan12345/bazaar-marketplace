import 'package:marketplace_shared/marketplace_shared.dart';

class ListingEntity {
  const ListingEntity({
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

  factory ListingEntity.fromModel(ListingModel model) {
    return ListingEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      price: model.price,
      category: model.category,
      city: model.city,
      images: model.images,
      ownerId: model.ownerId,
      ownerName: model.ownerName,
      ownerPhoto: model.ownerPhoto,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      viewCount: model.viewCount,
      isFeatured: model.isFeatured,
    );
  }
}
