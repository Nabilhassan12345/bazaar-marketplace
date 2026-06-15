import 'dart:typed_data';

import 'package:marketplace_shared/marketplace_shared.dart';

class SelectedListingImage {
  const SelectedListingImage({
    required this.id,
    required this.bytes,
    this.uploadProgress = 0,
    this.downloadUrl,
    this.isUploading = false,
    this.error,
  });

  final String id;
  final Uint8List bytes;
  final double uploadProgress;
  final String? downloadUrl;
  final bool isUploading;
  final String? error;

  bool get isUploaded => downloadUrl != null && !isUploading;

  bool get isRemoteOnly => bytes.isEmpty && downloadUrl != null;

  SelectedListingImage copyWith({
    double? uploadProgress,
    String? downloadUrl,
    bool? isUploading,
    String? error,
  }) {
    return SelectedListingImage(
      id: id,
      bytes: bytes,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isUploading: isUploading ?? this.isUploading,
      error: error,
    );
  }
}

class CreateListingState {
  const CreateListingState({
    this.currentStep = 0,
    this.title = '',
    this.description = '',
    this.priceText = '',
    this.category,
    this.countryCode,
    this.regionId,
    this.districtId,
    this.city,
    this.images = const [],
    this.listingId,
    this.isEditMode = false,
    this.originalStatus,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.errorMessage,
  });

  static const maxImages = 10;

  final int currentStep;
  final String title;
  final String description;
  final String priceText;
  final ListingCategory? category;
  final String? countryCode;
  final String? regionId;
  final String? districtId;
  /// Locality id stored in Firestore `city` field.
  final String? city;
  final List<SelectedListingImage> images;
  final String? listingId;
  final bool isEditMode;
  final ListingStatus? originalStatus;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? errorMessage;

  double? get price => double.tryParse(priceText);

  bool get canProceedFromDetails =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      price != null &&
      price! > 0 &&
      category != null &&
      countryCode != null &&
      regionId != null &&
      districtId != null &&
      city != null;

  bool get canProceedFromImages =>
      images.isNotEmpty &&
      images.every((image) => image.isUploaded || image.isRemoteOnly);

  bool get isUploadingImages => images.any((image) => image.isUploading);

  List<String> get imageUrls =>
      images.map((image) => image.downloadUrl).whereType<String>().toList();

  CreateListingState copyWith({
    int? currentStep,
    String? title,
    String? description,
    String? priceText,
    ListingCategory? category,
    String? countryCode,
    String? regionId,
    String? districtId,
    String? city,
    List<SelectedListingImage>? images,
    String? listingId,
    bool? isEditMode,
    ListingStatus? originalStatus,
    bool? isSubmitting,
    bool? submitSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateListingState(
      currentStep: currentStep ?? this.currentStep,
      title: title ?? this.title,
      description: description ?? this.description,
      priceText: priceText ?? this.priceText,
      category: category ?? this.category,
      countryCode: countryCode ?? this.countryCode,
      regionId: regionId ?? this.regionId,
      districtId: districtId ?? this.districtId,
      city: city ?? this.city,
      images: images ?? this.images,
      listingId: listingId ?? this.listingId,
      isEditMode: isEditMode ?? this.isEditMode,
      originalStatus: originalStatus ?? this.originalStatus,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
