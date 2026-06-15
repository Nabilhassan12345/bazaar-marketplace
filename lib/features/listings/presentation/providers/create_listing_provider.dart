import 'dart:typed_data';

import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/domain/repositories/listing_repository.dart';
import 'package:bazaar/features/listings/presentation/providers/create_listing_state.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_shared/marketplace_shared.dart';
import 'package:uuid/uuid.dart';

class CreateListingNotifier extends Notifier<CreateListingState> {
  final _picker = ImagePicker();
  final _uuid = const Uuid();

  @override
  CreateListingState build() => const CreateListingState();

  ListingRepository get _repository => ref.read(listingRepositoryProvider);

  BazaarStrings get _s => ref.read(bazaarStringsProvider);

  void setTitle(String value) => state = state.copyWith(title: value, clearError: true);
  void setDescription(String value) =>
      state = state.copyWith(description: value, clearError: true);
  void setPriceText(String value) =>
      state = state.copyWith(priceText: value, clearError: true);
  void setCategory(ListingCategory? value) =>
      state = state.copyWith(category: value, clearError: true);

  void setCountryCode(String? value) =>
      state = state.copyWith(countryCode: value, clearError: true);

  void setRegionId(String? value) =>
      state = state.copyWith(regionId: value, clearError: true);

  void setDistrictId(String? value) =>
      state = state.copyWith(districtId: value, clearError: true);

  void setCity(String? value) => state = state.copyWith(city: value, clearError: true);

  void goToStep(int step) => state = state.copyWith(currentStep: step, clearError: true);

  bool nextStep() {
    if (state.currentStep == 0 && !state.canProceedFromDetails) {
      state = state.copyWith(errorMessage: _s.errCompleteRequiredFields);
      return false;
    }
    if (state.currentStep == 1 && !state.canProceedFromImages) {
      state = state.copyWith(
        errorMessage: state.isUploadingImages
            ? _s.errWaitForUpload
            : _s.errAddOneImage,
      );
      return false;
    }
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1, clearError: true);
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1, clearError: true);
    }
  }

  Future<void> pickFromGallery() => _pickImages(ImageSource.gallery);

  Future<void> pickFromCamera() => _pickImages(ImageSource.camera);

  Future<void> _pickImages(ImageSource source) async {
    final remaining = CreateListingState.maxImages - state.images.length;
    if (remaining <= 0) {
      state = state.copyWith(errorMessage: _s.maxImagesError(CreateListingState.maxImages));
      return;
    }

    final List<XFile> picked;
    if (source == ImageSource.gallery) {
      picked = await _picker.pickMultiImage(limit: remaining);
    } else {
      final file = await _picker.pickImage(source: ImageSource.camera);
      picked = file == null ? [] : [file];
    }

    if (picked.isEmpty) return;

    final toAdd = picked.take(remaining).toList();
    for (final file in toAdd) {
      await _addAndUploadImage(file);
    }
  }

  Future<void> _addAndUploadImage(XFile file) async {
    final compressed = await _compressImage(file);
    final imageId = _uuid.v4();
    final listingId = state.listingId ?? _uuid.v4();

    final pending = SelectedListingImage(
      id: imageId,
      bytes: compressed,
      isUploading: true,
    );

    final index = state.images.length;
    state = state.copyWith(
      listingId: listingId,
      images: [...state.images, pending],
      clearError: true,
    );

    try {
      var lastProgress = 0.0;
      await for (final progress in _repository.uploadListingImage(
        listingId: listingId,
        index: index,
        imageBytes: compressed,
      )) {
        lastProgress = progress;
        _updateImage(imageId, (image) => image.copyWith(uploadProgress: progress));
      }

      final downloadUrl = await _repository.getImageDownloadUrl(
        listingId: listingId,
        index: index,
      );

      _updateImage(
        imageId,
        (image) => image.copyWith(
          uploadProgress: lastProgress > 0 ? lastProgress : 1,
          downloadUrl: downloadUrl,
          isUploading: false,
        ),
      );
    } catch (error) {
      _updateImage(
        imageId,
        (image) => image.copyWith(
          isUploading: false,
          error: error.toString(),
        ),
      );
      state = state.copyWith(errorMessage: _s.errImageUploadFailed);
    }
  }

  void removeImage(String imageId) {
    state = state.copyWith(
      images: state.images.where((image) => image.id != imageId).toList(),
      clearError: true,
    );
  }

  void _updateImage(
    String imageId,
    SelectedListingImage Function(SelectedListingImage image) update,
  ) {
    state = state.copyWith(
      images: [
        for (final image in state.images)
          if (image.id == imageId) update(image) else image,
      ],
    );
  }

  Future<Uint8List> _compressImage(XFile file) async {
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 800,
        quality: 70,
      );
      return Uint8List.fromList(result);
    }

    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800,
      quality: 70,
    );
    if (result != null) return result;
    return file.readAsBytes();
  }

  ListingModel? buildPreviewModel() {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    final listingId = state.listingId;
    if (user == null || listingId == null || !state.canProceedFromDetails) {
      return null;
    }

    final now = DateTime.now();
    return ListingModel(
      id: listingId,
      title: state.title.trim(),
      description: state.description.trim(),
      price: state.price!,
      category: state.category!,
      city: state.city!,
      countryCode: state.countryCode,
      regionId: state.regionId,
      districtId: state.districtId,
      images: state.imageUrls,
      ownerId: user.id,
      ownerName: user.displayName,
      ownerPhoto: user.photoUrl,
      status: state.isEditMode
          ? (state.originalStatus ?? ListingStatus.pendingReview)
          : ListingStatus.pendingReview,
      createdAt: now,
      updatedAt: now,
      viewCount: 0,
      isFeatured: false,
    );
  }

  Future<bool> submitListing() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    final listing = buildPreviewModel();

    if (user == null || listing == null || !state.canProceedFromImages) {
      state = state.copyWith(errorMessage: _s.errCompleteStepsBeforeSubmit);
      return false;
    }

    state = state.copyWith(
      currentStep: 3,
      isSubmitting: true,
      clearError: true,
    );

    try {
      if (state.isEditMode) {
        await _repository.updateListing(listing);
        state = state.copyWith(isSubmitting: false, submitSuccess: true);
        ref.invalidate(myListingsProvider);
        return true;
      }

      await _repository.createAndSubmitListing(listing);
      state = state.copyWith(isSubmitting: false, submitSuccess: true);
      ref.invalidate(myListingsProvider);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: _s.errSubmitFailed,
      );
      return false;
    }
  }

  void reset() => state = const CreateListingState();

  void loadForEdit(ListingEntity listing) {
    final loc = MarketGeography.localityById(listing.city);
    state = CreateListingState(
      listingId: listing.id,
      title: listing.title,
      description: listing.description,
      priceText: listing.price.toString(),
      category: listing.category,
      countryCode: loc?.countryCode,
      regionId: loc?.regionId,
      districtId: loc?.districtId,
      city: loc?.id ?? listing.city,
      images: [
        for (var i = 0; i < listing.images.length; i++)
          SelectedListingImage(
            id: 'existing_$i',
            bytes: Uint8List(0),
            downloadUrl: listing.images[i],
            uploadProgress: 1,
          ),
      ],
      isEditMode: true,
      originalStatus: listing.status,
    );
  }
}

final createListingProvider =
    NotifierProvider<CreateListingNotifier, CreateListingState>(
  CreateListingNotifier.new,
);
