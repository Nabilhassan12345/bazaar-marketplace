import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/constants/us_cities.dart';
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

    if (isEdit && !_editLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Listing')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isEdit &&
        _editLoaded &&
        ref.read(listingDetailProvider(widget.listingId!)).valueOrNull == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Listing')),
        body: const Center(child: Text('Listing not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Listing' : 'Create Listing'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: state.currentStep),
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
          Expanded(child: _buildStepContent(state, notifier)),
          _BottomActions(state: state, notifier: notifier),
        ],
      ),
    );
  }

  Widget _buildStepContent(CreateListingState state, CreateListingNotifier notifier) {
    return switch (state.currentStep) {
      0 => _DetailsStep(
          titleController: _titleController,
          descriptionController: _descriptionController,
          priceController: _priceController,
          category: state.category,
          city: state.city,
          onCategoryChanged: notifier.setCategory,
          onCityChanged: notifier.setCity,
          onTitleChanged: notifier.setTitle,
          onDescriptionChanged: notifier.setDescription,
          onPriceChanged: notifier.setPriceText,
        ),
      1 => _ImagesStep(
          images: state.images,
          onAddGallery: notifier.pickFromGallery,
          onAddCamera: notifier.pickFromCamera,
          onRemove: notifier.removeImage,
        ),
      2 => _PreviewStep(notifier: notifier),
      _ => _SubmitStep(state: state),
    };
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  static const _labels = ['Details', 'Images', 'Preview', 'Submit'];

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

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.category,
    required this.city,
    required this.onCategoryChanged,
    required this.onCityChanged,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onPriceChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ListingCategory? category;
  final String? city;
  final ValueChanged<ListingCategory?> onCategoryChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onPriceChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          minLines: 4,
          maxLines: 8,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceController,
          decoration: const InputDecoration(
            labelText: 'Price',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
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
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items: ListingCategory.values
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.label),
                ),
              )
              .toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          key: ValueKey(city),
          initialValue: city,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
          ),
          items: UsCities.all
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: onCityChanged,
        ),
      ],
    );
  }
}

class _ImagesStep extends StatelessWidget {
  const _ImagesStep({
    required this.images,
    required this.onAddGallery,
    required this.onAddCamera,
    required this.onRemove,
  });

  final List<SelectedListingImage> images;
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
          onAddGallery: onAddGallery,
          onAddCamera: onAddCamera,
          onRemove: onRemove,
        ),
        const SizedBox(height: 16),
        const Text(
          'Images are compressed (max 800px, 70% quality) and uploaded to Firebase Storage.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

class _PreviewStep extends ConsumerWidget {
  const _PreviewStep({required this.notifier});

  final CreateListingNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = notifier.buildPreviewModel();
    if (model == null) {
      return const Center(child: Text('Complete previous steps to preview.'));
    }

    final listing = ListingEntity.fromModel(model);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Preview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is how your listing will appear once approved.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        ListingCard(listing: listing),
      ],
    );
  }
}

class _SubmitStep extends StatelessWidget {
  const _SubmitStep({required this.state});

  final CreateListingState state;

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
              state.isEditMode ? 'Listing updated!' : 'Listing submitted!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.isEditMode
                  ? 'Your changes have been saved.'
                  : 'Your listing is pending review.',
            ),
          ],
        ),
      );
    }

    return Center(
      child: state.isSubmitting
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Submitting your listing...'),
              ],
            )
          : const Text('Ready to submit.'),
    );
  }
}

class _BottomActions extends ConsumerWidget {
  const _BottomActions({required this.state, required this.notifier});

  final CreateListingState state;
  final CreateListingNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: const Text('Go to My Listings'),
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
                child: const Text('Back'),
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
                          final success = await notifier.submitListing();
                          if (success && context.mounted) {
                            // Step 3 shows success UI.
                          }
                        }
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  state.currentStep == 2
                      ? (state.isEditMode ? 'Save Changes' : 'Submit for Review')
                      : state.currentStep == 3
                          ? 'Submitting...'
                          : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
