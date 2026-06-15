import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/core/widgets/market_location_picker.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/presentation/providers/create_listing_provider.dart';
import 'package:bazaar/features/listings/presentation/providers/create_listing_state.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_image_picker_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_shared/l10n/bazaar_strings.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class CreateListingPage extends ConsumerStatefulWidget {
  const CreateListingPage({this.listingId, super.key});

  final String? listingId;

  @override
  ConsumerState<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends ConsumerState<CreateListingPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  var _editLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.listingId == null) {
        ref.read(createListingProvider.notifier).reset();
      } else {
        _loadEditListing();
      }
    });
  }

  Future<void> _loadEditListing() async {
    final listing = await ref
        .read(listingRepositoryProvider)
        .getListingById(widget.listingId!);
    if (!mounted) return;
    if (listing == null) {
      setState(() => _editLoaded = true);
      return;
    }
    setState(() => _editLoaded = true);
    ref.read(createListingProvider.notifier).loadForEdit(listing);
    _titleController.text = listing.title;
    _descriptionController.text = listing.description;
    _priceController.text = listing.price.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createListingProvider);
    final notifier = ref.read(createListingProvider.notifier);
    final isEdit = widget.listingId != null;
    final s = ref.str;

    if (isEdit && !_editLoaded) {
      return Scaffold(
        appBar: AppBar(title: Text(s.editListing)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isEdit &&
        _editLoaded &&
        ref.read(listingDetailProvider(widget.listingId!)).valueOrNull == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.editListing)),
        body: Center(child: Text(s.listingNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? s.editListing : s.createListing),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: state.currentStep, strings: s),
          if (state.errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),
          Expanded(child: _buildStepContent(state, notifier, s)),
          _BottomActions(state: state, notifier: notifier),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    CreateListingState state,
    CreateListingNotifier notifier,
    BazaarStrings s,
  ) {
    return switch (state.currentStep) {
      0 => _DetailsStep(
          titleController: _titleController,
          descriptionController: _descriptionController,
          priceController: _priceController,
          category: state.category,
          countryCode: state.countryCode,
          regionId: state.regionId,
          districtId: state.districtId,
          city: state.city,
          onCategoryChanged: notifier.setCategory,
          onCountryChanged: notifier.setCountryCode,
          onRegionChanged: notifier.setRegionId,
          onDistrictChanged: notifier.setDistrictId,
          onCityChanged: notifier.setCity,
          onTitleChanged: notifier.setTitle,
          onDescriptionChanged: notifier.setDescription,
          onPriceChanged: notifier.setPriceText,
        ),
      1 => _ImagesStep(
          images: state.images,
          strings: s,
          onAddGallery: notifier.pickFromGallery,
          onAddCamera: notifier.pickFromCamera,
          onRemove: notifier.removeImage,
        ),
      2 => _PreviewStep(notifier: notifier, strings: s),
      _ => _SubmitStep(state: state, strings: s),
    };
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.strings});

  final int currentStep;
  final BazaarStrings strings;

  List<String> get _labels => [
        strings.stepDetails,
        strings.stepImages,
        strings.stepPreview,
        strings.stepSubmit,
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final isActive = index == currentStep;
          final isDone = index < currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: isActive || isDone
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive || isDone
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < _labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isDone ? AppColors.primary : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DetailsStep extends ConsumerWidget {
  const _DetailsStep({
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.category,
    required this.countryCode,
    required this.regionId,
    required this.districtId,
    required this.city,
    required this.onCategoryChanged,
    required this.onCountryChanged,
    required this.onRegionChanged,
    required this.onDistrictChanged,
    required this.onCityChanged,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onPriceChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ListingCategory? category;
  final String? countryCode;
  final String? regionId;
  final String? districtId;
  final String? city;
  final ValueChanged<ListingCategory?> onCategoryChanged;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onDistrictChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onPriceChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final languageCode = ref.watch(localeProvider).code;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: s.title,
            border: const OutlineInputBorder(),
          ),
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: s.description,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 8,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: s.price,
            prefixText: 'FCFA ',
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          onChanged: onPriceChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<ListingCategory>(
          key: ValueKey(category),
          initialValue: category,
          decoration: InputDecoration(
            labelText: s.category,
            border: const OutlineInputBorder(),
          ),
          items: ListingCategory.values
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.localizedLabel(s)),
                ),
              )
              .toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 16),
        MarketLocationPicker(
          languageCode: languageCode,
          countryCode: countryCode,
          regionId: regionId,
          districtId: districtId,
          localityId: city,
          countryLabel: s.country,
          regionLabel: s.region,
          districtLabel: s.district,
          localityLabel: s.city,
          onCountryChanged: onCountryChanged,
          onRegionChanged: onRegionChanged,
          onDistrictChanged: onDistrictChanged,
          onLocalityChanged: onCityChanged,
        ),
      ],
    );
  }
}

class _ImagesStep extends StatelessWidget {
  const _ImagesStep({
    required this.images,
    required this.strings,
    required this.onAddGallery,
    required this.onAddCamera,
    required this.onRemove,
  });

  final List<SelectedListingImage> images;
  final BazaarStrings strings;
  final VoidCallback onAddGallery;
  final VoidCallback onAddCamera;
  final void Function(String imageId) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListingImagePickerGrid(
          images: images,
          maxImages: CreateListingState.maxImages,
          photosLabel: strings.photosCount(images.length, CreateListingState.maxImages),
          galleryLabel: strings.gallery,
          cameraLabel: strings.camera,
          onAddGallery: onAddGallery,
          onAddCamera: onAddCamera,
          onRemove: onRemove,
        ),
        const SizedBox(height: 16),
        Text(
          strings.imagesCompressionNote,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _PreviewStep extends ConsumerWidget {
  const _PreviewStep({required this.notifier, required this.strings});

  final CreateListingNotifier notifier;
  final BazaarStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = notifier.buildPreviewModel();
    if (model == null) {
      return Center(child: Text(strings.completePreviousSteps));
    }

    final listing = ListingEntity.fromModel(model);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          strings.preview,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          strings.previewNote,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ListingCard(listing: listing),
      ],
    );
  }
}

class _SubmitStep extends StatelessWidget {
  const _SubmitStep({required this.state, required this.strings});

  final CreateListingState state;
  final BazaarStrings strings;

  @override
  Widget build(BuildContext context) {
    if (state.submitSuccess) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 16),
            Text(
              state.isEditMode ? strings.listingUpdated : strings.listingSubmitted,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.isEditMode
                  ? strings.listingChangesSaved
                  : strings.listingPendingReview,
            ),
          ],
        ),
      );
    }

    return Center(
      child: state.isSubmitting
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(strings.submittingListing),
              ],
            )
          : Text(strings.readyToSubmit),
    );
  }
}

class _BottomActions extends ConsumerWidget {
  const _BottomActions({required this.state, required this.notifier});

  final CreateListingState state;
  final CreateListingNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    if (state.submitSuccess) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              notifier.reset();
              context.goNamed(RouteKeys.myListings);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.primary,
            ),
            child: Text(s.goToMyListings),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (state.currentStep > 0 && !state.isSubmitting)
              OutlinedButton(
                onPressed: notifier.previousStep,
                child: Text(s.back),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                        if (state.currentStep < 2) {
                          notifier.nextStep();
                          return;
                        }
                        if (state.currentStep == 2) {
                          await notifier.submitListing();
                        }
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  state.currentStep == 2
                      ? (state.isEditMode ? s.saveChanges : s.submitForReview)
                      : state.currentStep == 3
                          ? s.submittingListing
                          : s.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
