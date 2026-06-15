import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ListingStorageDataSource {
  ListingStorageDataSource({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Stream<double> uploadListingImage({
    required String listingId,
    required int index,
    required List<int> imageBytes,
  }) async* {
    final ref = _storage.ref('listings/$listingId/$index.jpg');
    final uploadTask = ref.putData(
      Uint8List.fromList(imageBytes),
      SettableMetadata(contentType: 'image/jpeg'),
    );

    await for (final snapshot in uploadTask.snapshotEvents) {
      final total = snapshot.totalBytes;
      if (total > 0) {
        yield snapshot.bytesTransferred / total;
      }
    }
  }

  Future<String> getDownloadUrl({
    required String listingId,
    required int index,
  }) {
    return _storage.ref('listings/$listingId/$index.jpg').getDownloadURL();
  }
}
